class User {
  final String id;
  final String email;
  final String? username;
  final bool emailVerified;
  final String role;
  final bool isAdmin;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.emailVerified = false,
    this.role = 'user',
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      role: json['role'] as String? ?? 'user',
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }
}
