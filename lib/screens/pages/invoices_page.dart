import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// A placeholder page showing a list of invoices. Residents can view
/// uploaded invoices for each expense. Admins see the same list but
/// typically would navigate here via the quick action button.
class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).translate;
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.receipt_long),
          title: Text('${t('invoices')} #${index + 1}'),
          subtitle: const Text('View invoice PDF'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Open invoice ${index + 1}')),);
          },
        );
      },
    );
  }
}