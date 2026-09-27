class User {
  final String id;
  final String name;
  final String email;
  final int grade;
  final String role;
  final String createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.grade,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      grade: (json['grade'] as num?)?.toInt() ?? 9,
      role: json['role'] as String? ?? 'student',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'grade': grade,
      'role': role,
      'created_at': createdAt,
    };
  }
}
