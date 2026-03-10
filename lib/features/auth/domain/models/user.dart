class User {
  final String id;
  final String phone;
  final String? username;
  final String role;
  final bool isAdmin;

  const User({
    required this.id,
    required this.phone,
    this.username,
    this.role = 'user',
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String? ?? '',
      username: json['username'] as String?,
      role: json['role'] as String? ?? 'user',
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }
}
