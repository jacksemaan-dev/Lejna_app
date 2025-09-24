import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the visibility modes available to admins when controlling what
/// residents can see. See the acceptance criteria for details.
enum TransparencyMode { full, aggregated }

final visibilityProvider =
    StateNotifierProvider<VisibilityNotifier, TransparencyMode>((ref) {
  return VisibilityNotifier();
});

class VisibilityNotifier extends StateNotifier<TransparencyMode> {
  VisibilityNotifier() : super(TransparencyMode.full);

  void toggle() {
    state = state == TransparencyMode.full
        ? TransparencyMode.aggregated
        : TransparencyMode.full;
  }
}