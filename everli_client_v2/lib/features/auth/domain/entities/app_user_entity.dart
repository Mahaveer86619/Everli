class AppUserEntity {
  final String id;
  final String email;
  final String name;
  final String token;
  final String refreshToken;

  AppUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.refreshToken,
  });

  @override
  String toString() {
    return '''AppUserEntity(
    id: $id, 
    email: $email, 
    name: $name, 
    token: $token, 
    refreshToken: $refreshToken
    )''';
  }
}
