import 'package:everli_client_v2/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.bio,
    required super.skills,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      skills: json['skills'].cast<String>(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'skills': skills,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // to entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      bio: bio,
      skills: skills,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // to string
  @override
  String toString() {
    return '''UserModel{
    id: $id, 
    name: $name, 
    email: $email, 
    avatarUrl: $avatarUrl, 
    bio: $bio, 
    skills: $skills, 
    createdAt: $createdAt, 
    updatedAt: $updatedAt
    }''';
  }
}
