import 'package:cloud_functions/cloud_functions.dart';

/// Abstraction layer over callable Cloud Functions. Each function defined
/// here corresponds to a backend function deployed in the `functions`
/// folder. Errors are propagated to the caller.
class FunctionsService {
  final FirebaseFunctions _functions;

  FunctionsService({FirebaseFunctions? functions}) : _functions = functions ?? FirebaseFunctions.instance;

  Future<dynamic> generateReceipt(String buildingId, String paymentId) async {
    final result = await _functions.httpsCallable('generateReceipt').call({
      'buildingId': buildingId,
      'paymentId': paymentId,
    });
    return result.data;
  }

  Future<dynamic> generateMonthlyStatement(String buildingId, String period) async {
    final result = await _functions.httpsCallable('generateMonthlyStatement').call({
      'buildingId': buildingId,
      'period': period,
    });
    return result.data;
  }

  Future<dynamic> exportAll(String buildingId) async {
    final result = await _functions.httpsCallable('exportAll').call({'buildingId': buildingId});
    return result.data;
  }

  Future<dynamic> applyReferral(String referralCode, String newBuildingId) async {
    final result = await _functions.httpsCallable('applyReferral').call({
      'referralCode': referralCode,
      'newBuildingId': newBuildingId,
    });
    return result.data;
  }

  Future<void> notifyOnNewCharge(String buildingId) async {
    await _functions.httpsCallable('notifyOnNewCharge').call({'buildingId': buildingId});
  }

  Future<void> reminderDues(String buildingId) async {
    await _functions.httpsCallable('reminderDues').call({'buildingId': buildingId});
  }
}