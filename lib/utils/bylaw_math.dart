import '../models/unit.dart';

/// Splits a bylaw-based charge total across units according to their
/// [sharePerMille] values. The total charge amount is divided by the sum
/// of the shares (normally 1000) and each unit receives a pro rata
/// portion. If a unit is marked as [Unit.elevatorExempt] the share is
/// ignored when calculating elevator-related charges. This simplified
/// implementation assumes a single category; in a full app you would pass
/// the category and handle overrides per category.
Map<String, double> calculateBylawSplits(double totalAmount, List<Unit> units) {
  // Sum shares of all participating units.
  final totalShares = units.fold<int>(0, (sum, unit) => sum + unit.sharePerMille);
  if (totalShares == 0) {
    throw ArgumentError('Total shares cannot be zero');
  }
  final Map<String, double> results = {};
  for (final unit in units) {
    final ratio = unit.sharePerMille / totalShares;
    final amount = totalAmount * ratio;
    results[unit.id] = double.parse(amount.toStringAsFixed(2));
  }
  return results;
}