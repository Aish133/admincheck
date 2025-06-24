import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'sidebar.dart';
import 'top_navbar.dart';

import 'pages/sales_pages/sales.dart';
import 'pages/purchase_pages/purchase.dart';
import 'pages/store_pages/store.dart';
import 'pages/store_pages/store_layout.dart';
import 'pages/hr_pages/hr.dart';
import 'pages/hr_pages/manage_employee_layout.dart';
import 'pages/hr_pages/employee_details.dart';
import 'pages/hr_pages/edit_employee_details.dart';
import 'pages/hr_pages/attendance_layout.dart';
import 'pages/hr_pages/salary_layout.dart';
import 'pages/hr_pages/add_employee.dart';
import 'pages/birthday.dart';
import 'pages/sales_pages/sales_layout.dart';
import 'pages/purchase_pages/purchase_layout.dart';

class DashboardScreen extends StatelessWidget {
  final String? section;
  final String? tab;
  final String? subAction;

  const DashboardScreen({super.key, this.section, this.tab, this.subAction});


  @override
  Widget build(BuildContext context) {
    final currentSection = section ?? '';
    final currentTab = tab ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          const Sidebar(), // Sidebar handles navigation now
          Expanded(
            child: Column(
              children: [
                TopNavbar(
                  title: getTitle(currentSection),
                  section: currentSection,
                ),
                Expanded(
                  child: getPage(currentSection, currentTab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTitle(String section) {
    switch (section) {
      case 'sales':
        return 'Sales';
      case 'purchase':
        return 'Purchase';
      case 'store':
        return 'Store';
      case 'hr':
        return 'HR';
      case 'design':
        return 'Design';
      case 'production':
        return 'Production & Planning';
      case 'quality':
        return 'Quality';
      case 'account':
        return 'Account';
      case 'admin':
        return 'Admin';
      case 'setup':
        return 'Setup ERP';
      default:
        return 'Dashboard';
    }
  }

  Widget getPage(String section, String tab) {
    if (tab.isEmpty) {
      switch (section) {
        case 'sales':
          return const SalesLayout();
        case 'purchase':
          return const PurchaseLayout();
        case 'hr':
          return const BirthdayPage();
        case 'store':
          return StoreLayout();
        default:
          return const Center(child: Text("Main Dashboard Content", style: TextStyle(fontSize: 24)));
      }
    }

    switch (section) {
      case 'sales':
        return SalesPage(currentTab: tab); // or your actual tab string
      case 'purchase':
        return PurchasePage(currentTab: tab);
      case 'store':
        return StorePage(currentTab: tab);
      case 'hr':
        if(tab=='employee'){
          return ManageEmployeeLayout();
        }
        if(tab=='attendance'){
          return AttendanceLayout();
        }
        if(tab=='salary'){
          return SalaryLayout();
        }
        return HR(currentTab: tab);
      default:
        return const Center(child: Text("Feature coming soon", style: TextStyle(fontSize: 20)));
    }
  }

}