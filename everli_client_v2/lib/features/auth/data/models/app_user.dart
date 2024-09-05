import 'package:everli_client_v2/features/auth/domain/entities/app_user_entity.dart';

class AppUser extends AppUserEntity {
  AppUser({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
    required super.refreshToken,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        email: json['email'],
        name: json['username'],
        token: json['tokenKey'],
        refreshToken: json['refreshTokenKey'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': name,
        'tokenKey': token,
        'refreshTokenKey': refreshToken,
      };

  @override
  String toString() {
    return '''AppUserModel(
    id: $id, 
    email: $email, 
    name: $name, 
    token: $token, 
    refreshToken: $refreshToken
    )''';
  }
}
