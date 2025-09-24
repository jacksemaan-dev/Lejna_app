import 'package:firebase_analytics/firebase_analytics.dart';

/// Wraps Firebase Analytics to log events. Use this service to record
/// navigation events, user actions and referral achievements.
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  AnalyticsService({FirebaseAnalytics? analytics}) : _analytics = analytics ?? FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}