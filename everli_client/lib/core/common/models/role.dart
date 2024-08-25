class MyRole {
  final String id;
  final String memberId;
  final String eventId;
  final String role;
  final String createdAt;
  final String updatedAt;

  MyRole({
    required this.id,
    required this.memberId,
    required this.eventId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyRole.fromJson(Map<String, dynamic> json) {
    return MyRole(
      id: json['id'],
      memberId: json['member_id'],
      eventId: json['event_id'],
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'event_id': eventId,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  MyRole copyWith({
    String? id,
    String? memberId,
    String? eventId,
    String? role,
    String? createdAt,
    String? updatedAt,
  }) {
    return MyRole(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      eventId: eventId ?? this.eventId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''

      MyRole {
        id: $id,
        memberId: $memberId,
        eventId: $eventId,
        role: $role,
        createdAt: $createdAt,
        updatedAt: $updatedAt,
      }

''';
  }
}
