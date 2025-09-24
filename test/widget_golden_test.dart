import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lejna/app.dart';
import 'package:lejna/providers/auth_provider.dart';
import 'package:lejna/screens/home_screen.dart';
import 'package:lejna/screens/pages/dashboard_page.dart';
import 'package:lejna/screens/admin/create_charge_page.dart';
import 'package:lejna/screens/admin/add_payment_page.dart';
import 'package:lejna/screens/admin/add_expense_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Golden tests', () {
    testWidgets('Resident Dashboard', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DashboardPage())));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(DashboardPage),
        matchesGoldenFile('goldens/resident_dashboard.png'),
      );
    });
    testWidgets('Admin Dashboard', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: DashboardPage(isAdmin: true))));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(DashboardPage),
        matchesGoldenFile('goldens/admin_dashboard.png'),
      );
    });
    testWidgets('Create Charge Screen', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: CreateChargePage())));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CreateChargePage),
        matchesGoldenFile('goldens/create_charge.png'),
      );
    });
    testWidgets('Add Payment Screen', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AddPaymentPage())));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AddPaymentPage),
        matchesGoldenFile('goldens/add_payment.png'),
      );
    });
    testWidgets('Add Expense Screen', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AddExpensePage())));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AddExpensePage),
        matchesGoldenFile('goldens/add_expense.png'),
      );
    });
  });
}