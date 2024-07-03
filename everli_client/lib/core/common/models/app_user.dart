class AppUser {
  final String id;
  final String firebaseUid;
  final String username;
  final String email;
  final String avatarUrl;
  final String bio;
  final List<String> skills;

  AppUser({
    required this.id,
    required this.firebaseUid,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.skills,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      skills: (json['skills'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'skills': skills.map((skill) => skill).toList(),
    };
  }

  AppUser copyWith({
    String? id,
    String? firebaseUid,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? skills,
  }) {
    return AppUser(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
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
        firebaseUid: $firebaseUid,
        username: $username,
        email: $email,
        avatarUrl: $avatarUrl,
        bio: $bio,
        skills: $skills,
      }

''';
  }
}
