# Lejne Cloud Functions

This directory contains the backend logic for the Lejne application. All
functions are implemented using **TypeScript** and deployed to
Firebase Cloud Functions. To develop locally you will need Node.js
installed as well as the Firebase CLI. Install dependencies and build
the TypeScript sources:

```sh
cd functions
npm install
npm run build
```

## Available Functions

| Function                    | Description |
|----------------------------|-------------|
| `generateReceipt`          | Creates a PDF receipt for a payment, uploads it to Cloud Storage, and returns a signed URL. |
| `generateMonthlyStatement` | Builds a monthly statement PDF for a building (placeholder implementation) and returns its URL. |
| `exportAll`                | Generates a ZIP containing bylaws, receipts, invoices and reports for a building. Returns a signed URL. |
| `applyReferral`            | Applies referral credits according to the rules (1 month per referral, bonus 2 months at 6 referrals, capped at 8 per year). |
| `notifyOnNewCharge`        | Sends a push notification to residents when a new charge is created. |
| `reminderDues`             | Sends a dues reminder notification. Intended to be scheduled via Cloud Scheduler. |

### Environment Variables

No custom environment variables are currently required. Ensure that the
project’s default service account has permission to read/write Firestore,
send FCM messages, and read/write Cloud Storage.

### Deployment

Deploy functions using the Firebase CLI from the repository root:

```sh
firebase deploy --only functions
```

### Local Testing

Use the Firebase emulator suite to run functions locally:

```sh
firebase emulators:start --only functions
```

Ensure you have emulators for Firestore and Cloud Storage configured in
your `firebase.json` if you want to test interactions with those
services.
