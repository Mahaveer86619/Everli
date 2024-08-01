part of 'home_bloc.dart';

sealed class HomeEvent {}

class FetchAll extends HomeEvent {
  final String userId;

  FetchAll({required this.userId});
}

class FetchAppUser extends HomeEvent {}

class FetchMyEvents extends HomeEvent {
  final String userId;

  FetchMyEvents({required this.userId});
}

class FetchMyAssignments extends HomeEvent {
  final String userId;

  FetchMyAssignments({required this.userId});
}

class FetchMyCheckpoints extends HomeEvent {
  final String userId;

  FetchMyCheckpoints({required this.userId});
}