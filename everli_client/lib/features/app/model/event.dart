class MyEvent {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String creationDate;

  MyEvent({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.creationDate,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
      id: json['id'],
      creatorId: json['creator_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      tags: (json['tags'] as List).cast<String>(),
      creationDate: json['creation_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'tags': tags.map((tag) => tag).toList(),
      'creation_date': creationDate,
    };
  }

  MyEvent copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? tags,
    String? creationDate,
  }) {
    return MyEvent(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      creationDate: creationDate ?? this.creationDate,
    );
  }

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
        creationDate: $creationDate,
      }

''';
  }
}
