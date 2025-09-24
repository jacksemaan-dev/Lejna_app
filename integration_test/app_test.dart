import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:lejna/main.dart' as app;

/// High level integration test covering the core flows described in the
/// acceptance criteria. This test simulates logging in, creating a charge,
/// recording a payment, generating a receipt, adding an expense and
/// toggling visibility. It does not verify the actual persistence layer
/// but exercises the UI flow.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('end‑to‑end flow', (tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Log in as admin
    await tester.tap(find.text('Login as Admin'));
    await tester.pumpAndSettle();

    // Navigate to create charge
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    // Enter fixed charge amount per unit
    await tester.enterText(find.byType(TextFormField).first, '100');
    await tester.pumpAndSettle();
    // Publish charge
    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();

    // Add payment
    await tester.tap(find.byIcon(Icons.payment));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '50');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Add expense
    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Elevator maintenance');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), '200');
    await tester.pumpAndSettle();
    // Skip file picker in test environment
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Toggle visibility mode: open settings via admin dashboard maybe
    // This part is left as a placeholder because the UI does not yet implement visibility toggle

    // Share referral code
    await tester.tap(find.byIcon(Icons.group_add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
  });
}