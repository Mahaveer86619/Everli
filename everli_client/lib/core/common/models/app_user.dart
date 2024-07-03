class AppUser {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;
  final String bio;
  final List<String> skills;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.skills,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      skills: json['skills'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'skills': skills,
    };
  }

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? skills,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
    );
  }

  @override
  String toString() {
    return '''

      AppUser {
        id: $id,
        username: $username,
        email: $email,
        avatarUrl: $avatarUrl,
        bio: $bio,
        skills: $skills,
      }

''';
  }
}
