import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home.dart';
import 'dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    /// Default Dashboard (no section/tab)
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    /// Dashboard with section only (e.g. /dashboard/sales)
    GoRoute(
      path: '/dashboard/:section',
      name: 'dashboard-section',
      builder: (context, state) {
        final section = state.pathParameters['section']!;
        return DashboardScreen(section: section);
      },
    ),

    /// Dashboard with section and tab (e.g. /dashboard/sales/quotation)
    GoRoute(
      path: '/dashboard/:section/:tab',
      name: 'dashboard-tab',
      builder: (context, state) {
        final section = state.pathParameters['section']!;
        final tab = state.pathParameters['tab']!;
        return DashboardScreen(section: section, tab: tab);
      },
    ),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('jwt_token') != null;

    final isLoggingIn = state.matchedLocation == '/login';

    if (!hasToken && !isLoggingIn) {
      return '/login';
    }

    if (hasToken && isLoggingIn) {
      return '/home';
    }

    return null;
  },
);

