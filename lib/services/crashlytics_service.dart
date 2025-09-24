import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Reports uncaught errors to Firebase Crashlytics. Call
/// [CrashlyticsService.instance] to get the singleton instance.
class CrashlyticsService {
  CrashlyticsService._();
  static final CrashlyticsService instance = CrashlyticsService._();
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> recordError(dynamic error, StackTrace stack) async {
    await _crashlytics.recordError(error, stack);
  }
}