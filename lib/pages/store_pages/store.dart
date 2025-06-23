import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'additem_layout.dart';
import 'grn_layout.dart';
class StorePage extends StatefulWidget {
  final String currentTab;
  const StorePage({super.key, required this.currentTab});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  late TabController tabController;

  final List<String> tabs = ['item', 'grn', 'stock','challan','shortages','request','material'];

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    final initialIndex = tabs.indexOf(widget.currentTab.toLowerCase());
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        final newTab = tabs[tabController.index];
        context.go('/dashboard/store/$newTab');
      }
    });
  }

  @override
  void didUpdateWidget(covariant StorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentTab.toLowerCase() != widget.currentTab.toLowerCase()) {
      final newIndex = tabs.indexOf(widget.currentTab.toLowerCase());
      if (newIndex != -1 && newIndex != tabController.index) {
        tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Items'),
            Tab(text: 'GRN'),
            Tab(text: 'Stock'),
            Tab(text: 'Delivery Challan'),
            Tab(text: 'Shortages'),
            Tab(text: 'Purchase Request'),
            Tab(text: 'Material Request'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              AddItemLayout(),
              GrnPage(),
              Center(child: Text('Order Page')),
              Center(child: Text('Invoice Page')),
              Center(child: Text('Quotation Page')),
              Center(child: Text('Order Page')),
              Center(child: Text('Invoice Page')),
              Center(child: Text('Invoice Page')),
            ],
          ),
        ),
      ],
    );
  }
}
