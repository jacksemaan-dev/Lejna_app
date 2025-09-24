import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Displays a list of payment receipts. Each receipt can be tapped to
/// download or view a PDF containing a QR code for verification.
class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).translate;
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.description),
          title: Text('${t('receipts')} #${index + 1}'),
          subtitle: const Text('Receipt PDF with QR code'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Open receipt ${index + 1}')),);
          },
        );
      },
    );
  }
}