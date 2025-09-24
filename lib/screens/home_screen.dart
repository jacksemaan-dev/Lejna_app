import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'settings/settings_page.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../models/user.dart';
import 'pages/dashboard_page.dart';
import 'pages/invoices_page.dart';
import 'pages/receipts_page.dart';
import 'pages/reports_page.dart';
import 'pages/referrals_page.dart';

/// HomeScreen is the shell for both residents and admins. It contains a
/// bottom navigation bar to switch between the core pages. When the logged
/// in user is an admin a small menu item appears in the app bar that
/// routes to the admin dashboard.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).translate;
    final user = ref.watch(authProvider);

    final pages = [
      DashboardPage(isAdmin: user?.isAdmin ?? false),
      const InvoicesPage(),
      const ReceiptsPage(),
      const ReportsPage(),
      const ReferralsPage(),
    ];
    final labels = [
      t('dashboard'),
      t('invoices'),
      t('receipts'),
      t('reports'),
      t('referrals'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t('appTitle')),
        actions: [
          if (user?.isAdmin ?? false)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: t('adminDashboard'),
              onPressed: () {
                // navigate to admin dashboard via GoRouter
                // context.go is an extension method imported via go_router
                context.go('/admin');
              },
            ),
          // Settings button for all users
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: t('settings'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: t('logout'),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: List.generate(pages.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_iconForIndex(index)),
            label: labels[index],
          );
        }),
      ),
    );
  }

  IconData _iconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.receipt_long;
      case 2:
        return Icons.list_alt;
      case 3:
        return Icons.assessment;
      case 4:
        return Icons.group_add;
      default:
        return Icons.help;
    }
  }
}