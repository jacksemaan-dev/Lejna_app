import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../admin/add_expense_page.dart';
import '../admin/add_payment_page.dart';
import '../admin/create_charge_page.dart';

/// DashboardPage displays high level information about the building. For
/// residents this includes their balance and most recent expenses. Admins
/// additionally see KPIs and quick actions to manage charges, payments and
/// expenses.
class DashboardPage extends ConsumerWidget {
  final bool isAdmin;

  const DashboardPage({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context).translate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('dashboard'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _BalanceCard(),
          const SizedBox(height: 16),
          if (isAdmin) _AdminQuickActions(t: t) else _ResidentQuickActions(t: t),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // In the real app you would obtain these values from providers.
    final balance = 1500.0;
    final dues = 120.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance', style: Theme.of(context).textTheme.titleMedium),
                  Text('\$${balance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dues', style: Theme.of(context).textTheme.titleMedium),
                  Text('\$${dues.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminQuickActions extends StatelessWidget {
  final String Function(String) t;

  const _AdminQuickActions({required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: Text(t('createCharge')),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateChargePage(),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: Text(t('addPayment')),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddPaymentPage(),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt),
              label: Text(t('addExpense')),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddExpensePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ResidentQuickActions extends StatelessWidget {
  final String Function(String) t;
  const _ResidentQuickActions({required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: Text(t('invoices')),
              onPressed: () {},
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: Text(t('receipts')),
              onPressed: () {},
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.assessment),
              label: Text(t('reports')),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}