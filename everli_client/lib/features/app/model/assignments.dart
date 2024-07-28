class MyAssignment {
  final String id;
  final String eventId;
  final String? memberId;
  final String goal;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  MyAssignment({
    required this.id,
    required this.eventId,
    this.memberId = '',
    required this.goal,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory MyAssignment.fromJson(Map<String, dynamic> json) {
    return MyAssignment(
      id: json['id'],
      eventId: json['event_id'],
      memberId: json['member_id'],
      goal: json['goal'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'member_id': memberId,
      'goal': goal,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  MyAssignment copyWith({
    String? id,
    String? eventId,
    String? memberId,
    String? goal,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return MyAssignment(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      memberId: memberId ?? this.memberId,
      goal: goal ?? this.goal,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return '''

      MyAssignments {
        id: $id,
        eventId: $eventId,
        memberId: $memberId,
        goal: $goal,
        description: $description,
        dueDate: $dueDate,
        isCompleted: $isCompleted,
      }

''';
  }
}
