class MyRole {
  final String id;
  final String memberId;
  final String eventId;
  final String role;

  MyRole({
    required this.id,
    required this.memberId,
    required this.eventId,
    required this.role,
  });

  factory MyRole.fromJson(Map<String, dynamic> json) {
    return MyRole(
      id: json['id'],
      memberId: json['member_id'],
      eventId: json['event_id'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'event_id': eventId,
      'role': role,
    };
  }

  MyRole copyWith({
    String? id,
    String? memberId,
    String? eventId,
    String? role,
  }) {
    return MyRole(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      eventId: eventId ?? this.eventId,
      role: role ?? this.role,
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
      }

''';
  }
}
