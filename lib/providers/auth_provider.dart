import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

/// Riverpod provider that exposes authentication state. For the MVP we
/// simulate authentication by storing an [AppUser] instance. In a real
/// implementation you would subscribe to FirebaseAuth’s authStateChanges
/// stream and map that to your domain model.
final authProvider = StateNotifierProvider<AuthNotifier, AppUser?>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier() : super(null);

  /// Simulate a login by creating an [AppUser] with the supplied
  /// details. The `isAdmin` flag indicates whether the user should see
  /// administrative features.
  void login({required String id, required String name, required String email, bool isAdmin = false}) {
    state = AppUser(id: id, name: name, email: email, isAdmin: isAdmin);
  }

  /// Clears the current user.
  void logout() {
    state = null;
  }
}