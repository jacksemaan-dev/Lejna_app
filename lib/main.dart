import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_bootstrap.dart';
import 'services/notifications_service.dart';
import 'services/crashlytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before using any Firebase plugins.
  await Firebase.initializeApp();

  // Register background handler BEFORE runApp.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Request user permission for notifications (iOS shows system prompt; Android 13+ honors this too)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  // Ensure iOS shows alerts while app is in foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Initialize local notifications & bind foreground FCM listener
  await NotificationsService.instance.init();
  NotificationsService.instance.bindFirebaseForeground();

  // Optional: Crashlytics wiring you already had
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.dumpErrorToConsole(details);
    await CrashlyticsService.instance
        .recordError(details.exception, details.stack ?? StackTrace.current);
  };

  runApp(const ProviderScope(child: LejneApp()));
}
