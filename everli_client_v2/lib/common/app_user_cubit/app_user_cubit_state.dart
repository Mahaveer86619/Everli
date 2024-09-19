part of 'app_user_cubit_cubit.dart';

sealed class AppUserCubitState {}

final class AppUserInitial extends AppUserCubitState {}
final class AppUserAuthenticated extends AppUserCubitState {}
