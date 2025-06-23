import 'package:flutter/material.dart';
import 'attendance_layout.dart';
import 'manage_employee_layout.dart';
import 'holiday.dart';
import 'salary_layout.dart';
import 'package:go_router/go_router.dart';
class HR extends StatefulWidget {
  final String currentTab;
  const HR({super.key, required this.currentTab});

  @override
  State<HR> createState() => _HRState();
}

class _HRState extends State<HR> with TickerProviderStateMixin {
  late TabController tabController;

  final List<String> tabs = ['employee', 'attendance', 'salary','services','todo'];

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
        context.go('/dashboard/hr/$newTab');
      }
    });
  }

  @override
  void didUpdateWidget(covariant HR oldWidget) {
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
            Tab(text: 'Manage Employee'),
            Tab(text: 'Attendance'),
            Tab(text: 'Salary'),
            Tab(text: 'HR Services'),
            Tab(text: 'TO DO'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              ManageEmployeeLayout(),
              AttendanceLayout(),
              SalaryLayout(),
              HolidayScreen(),
              Center(child: Text("HR Services")),
            ],
          ),
        ),
      ],
    );
  }
}
