class MyCheckpoint {
  final String id;
  final String assignmentId;
  final String memberId;
  final String eventId;
  final String goal;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  MyCheckpoint({
    required this.id,
    required this.assignmentId,
    required this.memberId,
    required this.eventId,
    required this.goal,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory MyCheckpoint.fromJson(Map<String, dynamic> json) {
    return MyCheckpoint(
      id: json['id'],
      assignmentId: json['assignment_id'],
      memberId: json['member_id'],
      eventId: json['event_id'],
      goal: json['goal'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'member_id': memberId,
      'event_id': eventId,
      'goal': goal,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  MyCheckpoint copyWith({
    String? id,
    String? assignmentId,
    String? memberId,
    String? eventId,
    String? goal,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return MyCheckpoint(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      memberId: memberId ?? this.memberId,
      eventId: eventId ?? this.eventId,
      goal: goal ?? this.goal,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return '''

      MyCheckpoint {
        id: $id,
        assignmentId: $assignmentId,
        memberId: $memberId,
        eventId: $eventId,
        goal: $goal,
        description: $description,
        dueDate: $dueDate,
        isCompleted: $isCompleted,
      }

''';
  }
}
