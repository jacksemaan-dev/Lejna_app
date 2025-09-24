import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Displays monthly statements and exported reports. This page would allow
/// users to download their statement PDFs and CSV/Excel files. For now
/// it contains placeholder entries.
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).translate;
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: Text('${t('reports')} ${index + 1}/2025'),
          subtitle: const Text('Monthly statement PDF'),
          trailing: const Icon(Icons.download),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download report ${index + 1}/2025')),);
          },
        );
      },
    );
  }
}