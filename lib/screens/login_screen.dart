import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';

/// A very simple login screen used for demonstration. In the MVP this
/// screen lets you simulate logging in as an admin or resident. It also
/// includes a language toggle so you can verify RTL support.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context).translate;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t('appTitle'),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Log in as resident (non-admin)
                ref.read(authProvider.notifier).login(
                      id: 'user1',
                      name: 'Resident User',
                      email: 'resident@example.com',
                      isAdmin: false,
                    );
              },
              child: Text('Login as Resident'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Log in as admin
                ref.read(authProvider.notifier).login(
                      id: 'admin1',
                      name: 'Admin User',
                      email: 'admin@example.com',
                      isAdmin: true,
                    );
              },
              child: Text('Login as Admin'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t('language') + ': '),
                TextButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                  },
                  child: Text(t('english')),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                  },
                  child: Text(t('arabic')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}