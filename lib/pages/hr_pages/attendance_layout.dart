import 'package:flutter/material.dart';
import 'daily_records.dart';
import 'monthly_by_employee.dart';
import 'monthly_reports.dart';
import 'attendence_request.dart';
import 'package:go_router/go_router.dart';
class AttendanceLayout extends StatefulWidget {
  const AttendanceLayout({super.key});

  @override
  State<AttendanceLayout> createState() => _AttendanceLayoutState();
}

class _AttendanceLayoutState extends State<AttendanceLayout> {
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
            segments[2] == 'attendance')
        ? segments[3]
        : null;

    setState(() {
      switch (subAction) {
        case 'daily':
          _selectedPage = const DailyRecord();
          break;
          case 'monthly_employee':
          _selectedPage = const MonthlyByEmployee();
          break;
        case 'monthly_report':
          _selectedPage = const MonthlyReports();
          break;
        case 'request':
          _selectedPage = const AttendanceRequest();
          break;

        default:
          _selectedPage = const DailyRecord();
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
      case 'daily':
        context.go('/dashboard/hr/attendance/daily');
        break;
      case 'monthly_employee':
         context.go('/dashboard/hr/attendance/monthly_employee');
          break;
        case 'monthly_report':
          context.go('/dashboard/hr/attendance/monthly_report');
          break;
        case 'request':
          context.go('/dashboard/hr/attendance/request');
          break;

      case 'daily':
      default:
        context.go('/dashboard/hr/attendance');
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
                          value: 'daily',
                          child: Text('Daily Record'),
                        ),
                         PopupMenuItem(
                          value: 'monthly_employee',
                          child: Text('Monthly by Employee'),
                        ),
                         PopupMenuItem(
                          value: 'monthly_report',
                          child: Text('Monthly Reports'),
                        ),
                        PopupMenuItem(
                          value: 'request',
                          child: Text('Attendance Request'),
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
