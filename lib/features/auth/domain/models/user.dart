class User {
  final String id;
  final String phone;
  final String? username;
  final String role;
  final bool isAdmin;
  final bool needsOnboarding;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.phone,
    this.username,
    this.role = 'user',
    this.isAdmin = false,
    this.needsOnboarding = true,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String? ?? '',
      username: json['username'] as String?,
      role: json['role'] as String? ?? 'user',
      isAdmin: json['is_admin'] as bool? ?? false,
      needsOnboarding: json['needs_onboarding'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
