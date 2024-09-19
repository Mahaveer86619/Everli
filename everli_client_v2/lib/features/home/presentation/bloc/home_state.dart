part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

sealed class HomeState {
  final HomeStatus status;
  final String message;

  HomeState({
    required this.status,
    required this.message,
  });
}

final class HomeUserInfoFetched extends HomeState {
  final AppUserEntity user;

  HomeUserInfoFetched({
    required super.status,
    required super.message,
    required this.user,
  });
}

final class HomeSuccess extends HomeState {
  HomeSuccess({
    required super.status,
    required super.message,
  });
}

final class HomeError extends HomeState {
  HomeError({
    required super.status,
    required super.message,
  });
}