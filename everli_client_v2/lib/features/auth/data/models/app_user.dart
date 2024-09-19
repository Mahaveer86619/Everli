import 'package:everli_client_v2/features/auth/domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  final String token;
  final String refreshToken;

  AppUserModel({
    required super.id,
    required super.email,
    required super.name,
    required this.token,
    required this.refreshToken,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'],
      email: json['email'],
      name: json['username'],
      token: json['tokenKey'],
      refreshToken: json['refreshTokenKey'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': name,
        'tokenKey': token,
        'refreshTokenKey': refreshToken,
      };

  // a function to convert model to entity
  AppUserEntity toEntity() {
    return AppUserEntity(
      id: id,
      email: email,
      name: name,
    );
  }

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
