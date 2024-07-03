part of 'app_user_cubit.dart';

sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserAuthenticated extends AppUserState {}
