import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// AdminDashboardPage provides additional KPIs and administrative tools
/// separate from the main dashboard. In a full implementation this page
/// would allow managing units, bylaws, members and settings. Here we
/// display placeholder cards and actions.
class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).translate;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('adminDashboard')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _KpiCard(title: 'Total Balance', value: '\$1,500'),
          _KpiCard(title: 'Paid Percentage', value: '85%'),
          _KpiCard(title: 'Arrears', value: '\$200'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text(t('createCharge')),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text(t('addPayment')),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text(t('addExpense')),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}