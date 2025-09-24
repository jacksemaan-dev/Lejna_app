import 'package:firebase_messaging/firebase_messaging.dart';

/// Top-level background handler for FCM messages.
/// Must be a global function and annotated as an entry point.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this minimal: no heavy work here. Log or record if needed.
  // If you later need Firebase services here, initialize them explicitly.
  // await Firebase.initializeApp();
}
