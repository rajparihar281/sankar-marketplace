import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final String company;
  final DateTime joinedDate;
  final bool isGuest;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = 'Intern / Engineer',
    this.company = 'Sankar Group',
    DateTime? joinedDate,
    this.isGuest = false,
  }) : joinedDate = joinedDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'company': company,
      'joinedDate': joinedDate.toIso8601String(),
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      role: map['role'] ?? 'Intern / Engineer',
      company: map['company'] ?? 'Sankar Group',
      joinedDate: map['joinedDate'] != null
          ? DateTime.tryParse(map['joinedDate']) ?? DateTime.now()
          : DateTime.now(),
      isGuest: map['isGuest'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    String? company,
    DateTime? joinedDate,
    bool? isGuest,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      company: company ?? this.company,
      joinedDate: joinedDate ?? this.joinedDate,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

