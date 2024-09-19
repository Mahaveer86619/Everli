class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;
  final List<String> skills;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.skills,
    required this.createdAt,
    required this.updatedAt,
  });
  
}