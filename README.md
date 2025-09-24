# Lejne — Flutter App

This repository contains the Flutter mobile application and Firebase backend
for **Lejne**, a building committee management tool launching in
Lebanon. The app allows presidents, treasurers and residents to manage
dues, expenses, invoices, receipts and referrals with full transparency.

## Setup

1. **Install Flutter 3.x** (Dart null‑safety enabled). See
   <https://flutter.dev/docs/get-started/install>.
2. **Install the Firebase CLI** and login: `npm install -g firebase-tools` then
   `firebase login`.
3. Create a new Firebase project via the console and add both Android and
   iOS apps. Download the configuration files (`google-services.json` and
   `GoogleService-Info.plist`) into `android/app` and `ios/Runner` respectively.
4. Run `flutterfire configure` from the repo root to generate
   `firebase_options.dart` for your project.
5. Enable the following Firebase products in your project:
   - Authentication (email/OTP)
   - Firestore
   - Cloud Functions
   - Cloud Storage
   - Cloud Messaging
   - Crashlytics
   - Analytics

Run the app locally with:

```sh
flutter pub get
flutter run
```

### Icons & Splash

All launcher icons and branding assets are provided in
`L_icon_variations_final.zip`. Extract the zip and copy its contents into
`assets/icons/ios`, `assets/icons/android`, `assets/icons/vector` and
`assets/icons/play` as appropriate. The simplified “L” mark should be
used for the launcher icon, while the full wordmark (LEJNE) should be
used on the splash screen and marketing assets.

Icons have been added to `pubspec.yaml` under the `assets:` section.
Update your native configuration (`android/app/src/main/res` and
`ios/Runner/Assets.xcassets`) to reference these icons. Ensure the iOS
icons do not contain an alpha channel and that Android adaptive icons
respect safe areas.

### Localization

Localization is provided via a simple custom implementation in
`lib/l10n/app_localizations.dart`. Two languages are supported:
English (`en`) and Arabic (`ar`). The app will automatically flip the
layout to RTL when Arabic is selected. Add new strings to the maps in
that file and update the supported locales list. A language switcher is
available on the login screen.

## Backend

### Cloud Functions

Backend logic lives in the `functions/` directory. Functions are
implemented in TypeScript and compiled to Node.js for deployment. See
`functions/README.md` for details. To deploy:

```sh
cd functions
npm install
npm run build
firebase deploy --only functions
```

The following functions are available:

* **generateReceipt(paymentId)** – Creates a receipt PDF with QR code
  verification link, uploads to Storage and returns a signed URL.
* **generateMonthlyStatement(buildingId, period)** – Generates a monthly
  statement PDF summarising all transactions and invoices.
* **exportAll(buildingId)** – Bundles bylaws, receipts, invoices and
  statements into a ZIP and uploads it.
* **applyReferral(referralCode, newBuildingId)** – Applies referral
  credits to both buildings per the specification (+1 month per
  referral, +2 bonus at 6, cap 8/year).
* **notifyOnNewCharge(buildingId)** – Sends a push notification to
  residents when a new charge is created.
* **reminderDues(buildingId)** – Sends a dues reminder. Intended for
  scheduled invocation via Cloud Scheduler.

### Firestore Rules & Indexes

Security rules live in `firestore.rules` and enforce membership‑scoped
access:

* Residents can read unit, charge, payment and invoice documents tied
  to their building but cannot modify them.
* Admins can create new charges, payments, expenses and corrections
  (as ADJUSTMENT ledger entries) but cannot update or delete existing
  ledger entries.
* Auditors have read‑only access to all building documents.

Deploy the rules with:

```sh
firebase deploy --only firestore:rules
```

Composite indexes required for common queries are defined in
`firestore.indexes.json`. Deploy them via:

```sh
firebase deploy --only firestore:indexes
```

## Tests

### Unit Tests

Run all Dart unit tests with:

```sh
flutter test
```

Unit tests currently include bylaw maths (splitting totals according to
shares) in `test/bylaw_math_test.dart`.

### Golden Tests

Widget golden tests reside in `test/widget_golden_test.dart` and
reference placeholder golden images stored in `test/goldens/`. When
modifying UI elements you should update these golden files by running
`flutter test --update-goldens` on a machine with a configured Flutter
environment.

### Integration Tests

An end‑to‑end integration test is defined in
`integration_test/app_test.dart`. It exercises the core flow: logging in
as admin, creating charges, recording payments, adding expenses and
sharing a referral code. Run it with:

```sh
flutter test integration_test/app_test.dart
```

## Notes

* This MVP uses placeholder data and stubbed services. Integrate with
  Firestore and Storage by replacing the dummy implementations in
  `lib/services/` with real ones.
* The functions in `functions/src/index.ts` are simplified and omit
  error handling and detailed PDF generation. Extend them to include
  invoice thumbnails, tables and proper file structure.
* Invite tokens are validated in Cloud Functions (see docs) and should
  be short‑lived.

## Push Notifications

This project wires Firebase Cloud Messaging (FCM) but requires platform
configuration:

### iOS (APNs)

1. In the Apple Developer portal, create an **APNs Auth Key** (a .p8 file)
   and upload it to the Firebase console under **Project Settings → Cloud Messaging**.
2. In Xcode, open `ios/Runner.xcworkspace` and enable **Push
   Notifications** and **Background Modes → Remote notifications** in
   the target’s Signing & Capabilities.
3. Add the `FirebaseAppDelegateProxyEnabled` (Boolean, YES) and
   `FirebaseMessagingAutoInitEnabled` keys to your `Info.plist` as needed.
4. Implement foreground notification presentation in `AppDelegate` if you
   wish to display notifications while the app is open. See the
   `firebase_messaging` package documentation for details.

### Android

1. Ensure your `android/app/src/main/AndroidManifest.xml` includes the
   proper FCM service declarations. The FlutterFire configuration adds
   these automatically.
2. Create a notification channel on startup if targeting Android 8.0+
   using the `flutter_local_notifications` plugin (not included here).
3. Implement a background message handler by annotating a top‑level
   function with `@pragma('vm:entry-point')` and passing it to
   `FirebaseMessaging.onBackgroundMessage` in `main.dart`. See the
   `firebase_messaging` docs.

Without these platform steps push notifications will not be delivered.
