import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'customer_layout.dart';
class SalesPage extends StatefulWidget {
  final String currentTab;
  const SalesPage({super.key, required this.currentTab});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['customer', 'quotation', 'order', 'invoice'];

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    final initialIndex = tabs.indexOf(widget.currentTab.toLowerCase());
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final newTab = tabs[_tabController.index];
        context.go('/dashboard/sales/$newTab');
      }
    });
  }

  @override
  void didUpdateWidget(covariant SalesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the tab name has changed
    if (oldWidget.currentTab.toLowerCase() != widget.currentTab.toLowerCase()) {
      final newIndex = tabs.indexOf(widget.currentTab.toLowerCase());
      if (newIndex != -1 && newIndex != _tabController.index) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Customer'),
            Tab(text: 'Quotation'),
            Tab(text: 'Sales Order'),
            Tab(text: 'Sales Invoice'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              CustomerLayout(),
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
