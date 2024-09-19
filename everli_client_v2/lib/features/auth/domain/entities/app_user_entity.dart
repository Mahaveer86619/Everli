import 'package:everli_client_v2/common/constants/app_constants.dart';

class AppUserEntity {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  AppUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage = defaultAvatarUrl,
  });

  @override
  String toString() {
    return '''AppUserEntity(
    id: $id, 
    email: $email, 
    name: $name,
    )''';
  }
  
  factory AppUserEntity.fromJson(Map<String, dynamic> json) {
    return AppUserEntity(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }
}
