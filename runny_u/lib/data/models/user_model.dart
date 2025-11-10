// lib/data/models/user_model.dart

class UserModel {
  final String id;
  final String fullname;
  final String email;
  final DateTime creationDate;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.creationDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? fullname,
    String? email,
    DateTime? creationDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      creationDate: creationDate ?? this.creationDate,
    );
  }
}