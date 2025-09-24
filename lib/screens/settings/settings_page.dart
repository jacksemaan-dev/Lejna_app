import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../providers/visibility_provider.dart';
import '../../l10n/app_localizations.dart';

/// A settings page exposing admin controls such as the visibility toggle
/// and legal documents (Privacy Policy & Terms of Service). This page
/// could be expanded to include currency, blocks and referral codes.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(visibilityProvider);
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('settings'))),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(tr.translate('visibilityMode')),
            subtitle: Text(mode == TransparencyMode.full
                ? tr.translate('fullTransparency')
                : tr.translate('aggregated')),
            value: mode == TransparencyMode.full,
            onChanged: (_) => ref.read(visibilityProvider.notifier).toggle(),
          ),
          const Divider(),
          ListTile(
            title: Text(tr.translate('privacyPolicy')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LegalPage(
                    title: tr.translate('privacyPolicy'),
                    assetPath: 'assets/legal/privacy_policy.md',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text(tr.translate('termsOfService')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LegalPage(
                    title: tr.translate('termsOfService'),
                    assetPath: 'assets/legal/terms_of_service.md',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LegalPage extends StatelessWidget {
  final String title;
  final String assetPath;
  const LegalPage({super.key, required this.title, required this.assetPath});
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // Prepend the last updated line to the loaded document. If the
          // document is missing, fall back to a friendly error message.
          final data = '${tr.translate('lastUpdated')}.\n\n${snapshot.data ?? ''}';
          return Markdown(
            data: data,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          );
        },
      ),
    );
  }
}