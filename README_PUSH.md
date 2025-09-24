# Push Notifications Setup

This document outlines the necessary steps to configure push notifications for the **Lejne** app on both iOS and Android. The Flutter code already contains the plumbing to handle foreground and background messages via `firebase_messaging` and `flutter_local_notifications`; however, without the proper platform configuration notifications will not be delivered.

## iOS (Apple Push Notification service)

1. **Create an APNs Authentication Key**
   1. Log in to the [Apple Developer Portal](https://developer.apple.com/account/).
   2. Navigate to **Certificates, Identifiers & Profiles → Keys**.
   3. Click **“+”** to create a new key. Enter a name (e.g. `Lejne Push Key`) and enable **Apple Push Notifications Service (APNs)**.
   4. Download the generated `.p8` key file and note the **Key ID**. The key can only be downloaded once.

2. **Upload the APNs Key to Firebase**
   1. Open your project in the [Firebase Console](https://console.firebase.google.com/).
   2. Go to **Project settings → Cloud Messaging**.
   3. Under **iOS app configuration**, click **Upload** next to **APNs Authentication Key**.
   4. Provide the `.p8` file, your Apple developer **Team ID** (found in the Developer Portal under Membership), and the Key ID recorded earlier.

3. **Configure the iOS app**
   1. Ensure the `Bundle Identifier` in `ios/Runner.xcodeproj` matches the registered bundle in the Apple Developer portal.
   2. Open **Runner → Signing & Capabilities** in Xcode:
      - Add the **Push Notifications** capability.
      - Add the **Background Modes** capability and enable **Remote notifications**.
   3. Verify `aps-environment` is present in `ios/Runner/Runner.entitlements` for both Debug (`development`) and Release (`production`). Xcode adds this automatically when enabling Push Notifications.

4. **Request permission and handle tokens**
   - The Flutter code calls `FirebaseMessaging.requestPermission()` and registers a background handler in `push_bootstrap.dart`. Make sure you run the app on a physical device; the iOS Simulator does not support APNs.
   - When the app runs for the first time, iOS will prompt for notification permissions. Accepting will allow FCM to deliver notifications.

5. **Testing**
   - In the Firebase console, navigate to **Cloud Messaging** and click **Send your first message** or **Send test message**.
   - Enter a title/body, then select **Test on device** and paste the FCM token printed in your app logs.
   - For **foreground** messages, you should see a banner with sound. For **background/terminated** messages, tapping the notification should open the app.

## Android

1. **Add a small notification icon**
   - Create a monochrome icon named `ic_stat_lejne` and place it under each `android/app/src/main/res/mipmap-*` directory. This icon is used by the notification channel for heads‑up messages.

2. **Define a notification channel and permission**
   - The Flutter code creates a channel named `lejne_default` with high importance. Nothing additional is needed, but you may customise the channel description or sound in `NotificationsService`.
   - On Android 13 (API 33) and above, you must request the `POST_NOTIFICATIONS` runtime permission. When `FirebaseMessaging.requestPermission()` is called the plugin automatically prompts the user.

3. **Configure the manifest**
   - Ensure the following services are declared in `android/app/src/main/AndroidManifest.xml` (these entries are added when you run `flutterfire configure`, but double‑check):
     ```xml
     <service android:name="io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService" android:exported="true">
         <intent-filter>
             <action android:name="com.google.firebase.MESSAGING_EVENT" />
         </intent-filter>
     </service>
     <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
     <receiver android:name="com.dexterous.flutterlocalnotifications.NotificationAlarmReceiver" />
     ```

## In‑App Behaviour

* **Foreground messages**: When a notification is received while the app is open, `NotificationsService` will display a heads‑up banner on Android and a banner on iOS using `flutter_local_notifications`. The notification will show the title and body sent from FCM.

* **Background/terminated messages**: These are delivered by the native OS. Tapping the notification will open the app. The background handler defined in `push_bootstrap.dart` prevents crashes and can be used for lightweight background processing if required.

## Troubleshooting

* Make sure your Firebase project has **APNs** configured and that you are using a physical iOS device.
* Double‑check that the bundle identifier and entitlements match between Xcode and Firebase.
* If notifications do not show on Android, verify that the `ic_stat_lejne` icon exists in every density folder. Missing icons can cause notifications to be silently dropped.
* For additional debugging, monitor `adb logcat` on Android and `Console.app` on macOS for iOS logs.