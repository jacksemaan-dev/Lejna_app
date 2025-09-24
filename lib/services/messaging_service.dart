import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handles Firebase Cloud Messaging initialization and token management.
class MessagingService {
  final FirebaseMessaging _messaging;
  MessagingService({FirebaseMessaging? messaging}) : _messaging = messaging ?? FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions for iOS
    if (!kIsWeb) {
      await _messaging.requestPermission();
    }
    // Optionally handle background messages here
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}