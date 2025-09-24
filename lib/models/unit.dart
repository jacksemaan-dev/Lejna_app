/// Represents a unit (apartment) within a building. Units are assigned a
/// sharePerMille value indicating how much of bylaw-based charges they
/// should pay relative to the building total (out of 1000). Optional
/// overrides can specify categories (e.g. elevator) that a unit is
/// exempt from.
class Unit {
  final String id;
  final String label;
  final int sharePerMille;
  final bool elevatorExempt;

  const Unit({
    required this.id,
    required this.label,
    required this.sharePerMille,
    this.elevatorExempt = false,
  });
}