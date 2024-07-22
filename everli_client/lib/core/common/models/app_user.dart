class AppUser {
  final String id;
  final String firebaseUid;
  final String username;
  final String email;
  final String avatarUrl;
  final String bio;
  final List<String> skills;
  final String createdAt;
  final String updatedAt;

  AppUser({
    required this.id,
    required this.firebaseUid,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.skills,
    required this.createdAt,
    required this.updatedAt,
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'created_at': createdAt,
      "updated_at": updatedAt,
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
    String? createdAt,
    String? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
        createdAt: $createdAt,
        updatedAt: $updatedAt,
      }

''';
  }
}
