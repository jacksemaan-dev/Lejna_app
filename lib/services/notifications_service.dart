import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Singleton wrapper around flutter_local_notifications + FCM foreground binding.
class NotificationsService {
  NotificationsService._();
  static final NotificationsService instance = NotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Android init: use a monochrome small icon placed at:
    // android/app/src/main/res/mipmap-*/ic_stat_lejne.png
    const androidInit = AndroidInitializationSettings('@mipmap/ic_stat_lejne');

    // iOS (Darwin) init + request perms here for local notifications
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);

    // Create a default channel for heads-up foreground notifications on Android
    const channel = AndroidNotificationChannel(
      'lejne_default',
      'General',
      description: 'General notifications',
      importance: Importance.high,
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(channel);

    _initialized = true;
  }

  /// Binds FCM onMessage to show a heads-up notification when app is foregrounded.
  void bindFirebaseForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final n = message.notification;
      final android = message.notification?.android;
      if (n != null) {
        _plugin.show(
          n.hashCode,
          n.title ?? 'Notification',
          n.body ?? '',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'lejne_default',
              'General',
              channelDescription: 'General notifications',
              importance: Importance.high,
              priority: Priority.high,
              icon: android?.smallIcon ?? '@mipmap/ic_stat_lejne',
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    });
  }
}
