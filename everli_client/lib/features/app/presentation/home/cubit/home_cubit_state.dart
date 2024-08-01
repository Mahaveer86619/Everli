part of 'home_cubit.dart';

sealed class HomeCubitState {}

final class HomeCubitInitial extends HomeCubitState {}

final class HomeCubitLoading extends HomeCubitState {}

final class HomeEventMembersLoaded extends HomeCubitState {
  final List<AppUser> members;

  HomeEventMembersLoaded({required this.members});
}

final class HomeCubitError extends HomeCubitState {
  final String message;

  HomeCubitError({required this.message});
}