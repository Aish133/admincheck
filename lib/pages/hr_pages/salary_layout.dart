import 'package:flutter/material.dart';
import 'salary_ledger.dart';
import 'advance_ledger.dart';
import 'package:go_router/go_router.dart';
class SalaryLayout extends StatefulWidget {
  const SalaryLayout({super.key});

  @override
  State<SalaryLayout> createState() => _SalaryLayoutState();
}

class _SalaryLayoutState extends State<SalaryLayout> {
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
            segments[2] == 'salary')
        ? segments[3]
        : null;

    setState(() {
      switch (subAction) {
        case 'salary':
          _selectedPage = const SalaryLedger();
          break;
        case 'advance':
          _selectedPage = const AdvanceLedger();
          break;
        default:
          _selectedPage = const SalaryLedger();
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
      case 'salary':
        context.go('/dashboard/hr/salary/salary');
        break;
      case 'advance':
        context.go('/dashboard/hr/salary/advance');
        break;
      case 'salary':
      default:
        context.go('/dashboard/hr/salary');
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
                          value: 'salary',
                          child: Text('Salary Ledger'),
                        ),
                         PopupMenuItem(
                          value: 'advance',
                          child: Text('Advance Ledger'),
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
