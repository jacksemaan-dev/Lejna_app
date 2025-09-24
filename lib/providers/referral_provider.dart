import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds referral information for the current building. For the MVP this
/// provider contains a referral code and the number of successful
/// referrals. In a real implementation this would be fetched from
/// Firestore. When the count reaches 6 a bonus will be applied.
class ReferralInfo {
  final String code;
  final int count;

  const ReferralInfo({required this.code, required this.count});
}

final referralProvider = Provider<ReferralInfo>((ref) {
  // Placeholder: return a hard coded referral code and count. In the real
  // app you would listen to a document in Firestore and return a stream.
  return const ReferralInfo(code: 'LEJNE2025', count: 3);
});