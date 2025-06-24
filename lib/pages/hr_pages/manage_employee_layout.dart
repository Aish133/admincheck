import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'add_employee.dart';
import 'edit_employee_details.dart';
import 'employee_details.dart';

class ManageEmployeeLayout extends StatefulWidget {
  const ManageEmployeeLayout({super.key});

  @override
  State<ManageEmployeeLayout> createState() => _ManageEmployeeLayoutState();
}

class _ManageEmployeeLayoutState extends State<ManageEmployeeLayout> {
  late Widget _selectedPage;
  RouteInformationProvider? _routeInfoProvider;

  /// Parse current route and update the selected page
  void _updatePageFromUri() {
    final location =
        GoRouter.of(context).routeInformationProvider.value.location ?? '';
    final uri = Uri.parse(location);
    final segments = uri.pathSegments;

    String? subAction = (segments.length >= 4 &&
            segments[0] == 'dashboard' &&
            segments[1] == 'hr' &&
            segments[2] == 'employee')
        ? segments[3]
        : null;

    setState(() {
      switch (subAction) {
        case 'add':
          _selectedPage = const AddEmployee();
          break;
        case 'edit':
          _selectedPage = const ShowEmployeeDetails();
          break;
        default:
          _selectedPage = const EmployeeDetails();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routeInfoProvider ??= GoRouter.of(context).routeInformationProvider;
    _routeInfoProvider!.addListener(_updatePageFromUri);
    _updatePageFromUri(); // Also call once at first build
  }

  @override
  void dispose() {
    _routeInfoProvider?.removeListener(_updatePageFromUri);
    super.dispose();
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'add':
        context.go('/dashboard/hr/employee/add');
        break;
      case 'edit':
        context.go('/dashboard/hr/employee/edit');
        break;
      case 'details':
      default:
        context.go('/dashboard/hr/employee');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Popup menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: _onMenuSelected,
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'details',
                          child: Text('Employee Details'),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Employee Details'),
                        ),
                        PopupMenuItem(
                          value: 'add',
                          child: Text('Add Employee'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                // Dynamic content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _selectedPage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
