import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_arrow.dart';

enum SidebarSection {
  none,
  sales,
  purchase,
  design,
  store,
  production,
  quality,
  account,
  hr,
  admin,
  setup,
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  SidebarSection expandedSection = SidebarSection.none;

  void toggleExpansion(SidebarSection section) {
    setState(() {
      expandedSection = expandedSection == section ? SidebarSection.none : section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 70,
              child: Image.asset('assets/images/sunshine_logo.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildTile("Sales", Icons.point_of_sale, SidebarSection.sales, () {
                  context.go('/dashboard/sales');
                }, [
                  _buildSubItem(context, "Customer", 'customer', 'sales'),
                  _buildSubItem(context, "Quotation", 'quotation', 'sales'),
                  _buildSubItem(context, "Sales Order", 'order', 'sales'),
                  _buildSubItem(context, "Sales Invoice", 'invoice', 'sales'),
                ]),
                buildTile("Purchase", Icons.shopping_cart, SidebarSection.purchase, () {
                  context.go('/dashboard/purchase');
                }, [
                  _buildSubItem(context, "Suppliers", 'suppliers', 'purchase'),
                  _buildSubItem(context, "Quote", 'quote', 'purchase'),
                  _buildSubItem(context, "Purchase Order", 'order', 'purchase'),
                  _buildSubItem(context, "Purchase Invoice", 'invoice', 'purchase'),
                ]),
                buildTile("Design", Icons.design_services, SidebarSection.design, () {
                  context.go('/dashboard/design');
                }, [
                  _buildSubItem(context, "Design Dashboard", 'dashboard', 'design'),
                  _buildSubItem(context, "Add BOM", 'bom', 'design'),
                  _buildSubItem(context, "Add Test Report", 'report', 'design'),
                ]),
                buildTile("Store", Icons.store, SidebarSection.store, () {
                  context.go('/dashboard/store');
                }, [
                  _buildSubItem(context, "Item", 'item', 'store'),
                  _buildSubItem(context, "GRN", 'grn', 'store'),
                  _buildSubItem(context, "Stock", 'stock', 'store'),
                  _buildSubItem(context, "Delivery challan", 'challan', 'store'),
                  _buildSubItem(context, "Shortages", 'shortages', 'store'),
                  _buildSubItem(context, "Purchase ReQuest", 'request', 'store'),
                  _buildSubItem(context, "Material Request", 'material', 'store'),
                ]),
                buildTile("Production", Icons.factory, SidebarSection.production, () {
                  context.go('/dashboard/production');
                }, [
                  _buildSubItem(context, "Production Plan", 'plan', 'production'),
                ]),
                buildTile("Quality", Icons.verified, SidebarSection.quality, () {
                  context.go('/dashboard/quality');
                }, [
                  _buildSubItem(context, "SOP", 'sop', 'quality'),
                ]),
                buildTile("Account", Icons.account_balance, SidebarSection.account, () {
                  context.go('/dashboard/account');
                }, [
                  _buildSubItem(context, "D", 'd', 'account'),
                  _buildSubItem(context, "Ledger", 'ledger', 'account'),
                ]),
                buildTile("HR", Icons.people, SidebarSection.hr, () {
                  context.go('/dashboard/hr');
                }, [
                  _buildSubItem(context, "Manage Employee", 'employee', 'hr'),
                  _buildSubItem(context, "Attendance", 'attendance', 'hr'),
                  _buildSubItem(context, "Salary", 'salary', 'hr'),
                  _buildSubItem(context, "HR Services", 'services', 'hr'),
                  _buildSubItem(context, "To Do", 'todo', 'hr'),
                ]),
                buildTile("Admin", Icons.admin_panel_settings, SidebarSection.admin, () {
                  context.go('/dashboard/admin');
                }, [
                  _buildSubItem(context, "System", 'system', 'admin'),
                ]),
                buildTile("Setup ERP", Icons.settings, SidebarSection.setup, () {
                  context.go('/dashboard/setup');
                }, [
                  _buildSubItem(context, "Create Master", 'master', 'setup'),
                ]),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () => print("Logout tapped"),
          ),
        ],
      ),
    );
  }

  Widget buildTile(String title, IconData icon, SidebarSection section, VoidCallback onTitleTap, List<Widget> children) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: CustomExpansionTileWithArrowTap(
        title: title,
        icon: icon,
        isExpanded: expandedSection == section,
        onTitleTap: onTitleTap, // ✅ Navigate on title tap
        onArrowTap: () => toggleExpansion(section), // ✅ Expand/collapse on arrow tap
        children: children,
      ),
    );
  }

  Widget _buildSubItem(BuildContext context, String label, String tab, String section) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      onTap: () {
        context.go('/dashboard/$section/$tab');
      },
    );
  }
}
