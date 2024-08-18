import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/models/event.dart';

class JoinedEventsModel {
  final MyEvent event;
  final List<AppUser> members;

  JoinedEventsModel({
    required this.event,
    required this.members,
  });

  JoinedEventsModel copyWith({
    MyEvent? event,
    List<AppUser>? members,
  }) {
    return JoinedEventsModel(
      event: event ?? this.event,
      members: members ?? this.members,
    );
  }

  factory JoinedEventsModel.empty() => JoinedEventsModel(
        event: MyEvent.empty(),
        members: [],
      );

  JoinedEventsModel.fromJson(Map<String, dynamic> json)
      : event = MyEvent.fromJson(json['event']),
        members =
            List<AppUser>.from(json['members'].map((x) => AppUser.fromJson(x)));

  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''
    JoinedEventsModel(
    event: $event,
    members: $members
    )
    ''';
  }
}
