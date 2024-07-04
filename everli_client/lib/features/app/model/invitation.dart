class MyInvitation {
  final String id;
  final String code;
  final String eventId;
  final String role;

  MyInvitation({
    required this.id,
    required this.code,
    required this.eventId,
    required this.role,
  });

  factory MyInvitation.fromJson(Map<String, dynamic> json) {
    return MyInvitation(
      id: json['id'],
      code: json['code'],
      eventId: json['event_id'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'event_id': eventId,
      'role': role,
    };
  }

  MyInvitation copyWith({
    String? id,
    String? code,
    String? eventId,
    String? role,
  }) {
    return MyInvitation(
      id: id ?? this.id,
      code: code ?? this.code,
      eventId: eventId ?? this.eventId,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return '''

      MyInvitation {
        id: $id,
        code: $code,
        eventId: $eventId,
        role: $role,
      }

''';
  }
}
