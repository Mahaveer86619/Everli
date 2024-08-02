part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<MyEvent> events;
  final List<MyAssignment> assignments;
  final List<MyCheckpoint> checkpoints;

  HomeLoaded({
    required this.events,
    required this.assignments,
    required this.checkpoints,
  });
}

final class HomeUserLoaded extends HomeState {
  final AppUser user;

  HomeUserLoaded({required this.user});
}

final class HomeEventLoaded extends HomeState {
  final List<JoinedEventsModel> events;

  HomeEventLoaded({required this.events});
}

final class HomeEventMembersLoaded extends HomeState {
  final List<AppUser> members;

  HomeEventMembersLoaded({required this.members});
}

final class HomeAssignmentsLoaded extends HomeState {
  final List<MyAssignment> assignments;

  HomeAssignmentsLoaded({required this.assignments});
}

final class HomeCheckpointsLoaded extends HomeState {
  final List<MyCheckpoint> checkpoints;

  HomeCheckpointsLoaded({required this.checkpoints});
}

final class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}