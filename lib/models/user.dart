/// A simple user model used within the Lejne MVP.
///
/// In a production application this would be replaced by Firebase
/// Authentication’s [User] type. Only the fields used by the UI are
/// defined here.
class AppUser {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
  });
}