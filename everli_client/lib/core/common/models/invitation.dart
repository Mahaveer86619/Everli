class MyInvitation {
  final String id;
  final String code;
  final String eventId;
  final String role;
  final String expiry;
  final String createdAt;

  MyInvitation({
    required this.id,
    required this.code,
    required this.eventId,
    required this.role,
    required this.expiry,
    required this.createdAt,
  });

  factory MyInvitation.fromJson(Map<String, dynamic> json) {
    return MyInvitation(
      id: json['id'],
      code: json['code'],
      eventId: json['event_id'],
      role: json['role'],
      expiry: json['expiry'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'event_id': eventId,
      'role': role,
      'expiry': expiry,
      'created_at': createdAt,
    };
  }

  MyInvitation copyWith({
    String? id,
    String? code,
    String? eventId,
    String? role,
    String? expiry,
    String? createdAt,
  }) {
    return MyInvitation(
      id: id ?? this.id,
      code: code ?? this.code,
      eventId: eventId ?? this.eventId,
      role: role ?? this.role,
      expiry: expiry ?? this.expiry,
      createdAt: createdAt ?? this.createdAt,
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
        expiry: $expiry,
        createdAt: $createdAt,
      }

''';
  }

  factory MyInvitation.empty() => MyInvitation(
        id: '',
        code: '',
        eventId: '',
        role: '',
        expiry: '',
        createdAt: '',
      );
}
