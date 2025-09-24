import 'package:flutter_test/flutter_test.dart';

import 'package:lejna/utils/bylaw_math.dart';
import 'package:lejna/models/unit.dart';

void main() {
  group('calculateBylawSplits', () {
    test('splits total amount proportionally', () {
      final units = [
        const Unit(id: 'u1', label: 'Apt 1', sharePerMille: 250),
        const Unit(id: 'u2', label: 'Apt 2', sharePerMille: 250),
        const Unit(id: 'u3', label: 'Apt 3', sharePerMille: 500),
      ];
      final result = calculateBylawSplits(1000.0, units);
      expect(result['u1'], closeTo(250.0, 0.01));
      expect(result['u2'], closeTo(250.0, 0.01));
      expect(result['u3'], closeTo(500.0, 0.01));
    });

    test('throws when total shares are zero', () {
      expect(
        () => calculateBylawSplits(100.0, [const Unit(id: 'u', label: 'A', sharePerMille: 0)]),
        throwsArgumentError,
      );
    });
  });
}