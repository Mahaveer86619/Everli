import 'package:everli_client/core/common/constants/app_constants.dart';

class MyEvent {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  MyEvent({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
      id: json['id'],
      creatorId: json['creator_id'],
      title: json['name'],
      description: json['description'],
      imageUrl: json['cover_image_url'],
      tags: (json['tags'] as List).cast<String>(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'name': title,
      'description': description,
      'cover_image_url': imageUrl ?? defaultEventImageUrl,
      'tags': tags.map((tag) => tag).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  MyEvent copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
  }) {
    return MyEvent(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MyEvent.empty() => MyEvent(
      id: '',
      creatorId: '',
      title: '',
      description: '',
      imageUrl: '',
      tags: [],
      createdAt: '',
      updatedAt: '',
    );

  @override
  String toString() {
    return '''

      MyEvent {
        id: $id,
        creatorId: $creatorId,
        title: $title,
        description: $description,
        imageUrl: $imageUrl,
        tags: $tags,
        createdAt: $createdAt,
        updatedAt: $updatedAt,
      }

''';
  }
}
