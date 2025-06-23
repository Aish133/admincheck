import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'supplier_layout.dart';

class PurchasePage extends StatefulWidget {
  final String currentTab;
  const PurchasePage({super.key, required this.currentTab});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> with TickerProviderStateMixin {
  late TabController tabController;

  final List<String> tabs = ['supplier', 'quote', 'order', 'invoice'];

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
        context.go('/dashboard/purchase/$newTab');
      }
    });
  }

  @override
  void didUpdateWidget(covariant PurchasePage oldWidget) {
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
            Tab(text: 'Suppliers'),
            Tab(text: 'Quote'),
            Tab(text: 'Purchase Order'),
            Tab(text: 'Purchase Invoice'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              SupplierLayout(),
              Center(child: Text('Quotation Page')),
              Center(child: Text('Order Page')),
              Center(child: Text('Invoice Page')),
            ],
          ),
        ),
      ],
    );
  }
}
