part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final AppUser user;

  HomeLoaded({required this.user});
}

final class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}