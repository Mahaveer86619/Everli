import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/repository/app_user_repository.dart';
import 'package:everli_client/features/app/presentation/chat/bloc/chat_bloc.dart';
import 'package:everli_client/features/app/presentation/chat/repository/chat_repository.dart';
import 'package:everli_client/features/app/presentation/home/bloc/home_bloc.dart';
import 'package:everli_client/features/app/presentation/home/repository/home_repository.dart';
import 'package:everli_client/features/app/presentation/profile/bloc/profile_bloc.dart';
import 'package:everli_client/features/app/presentation/profile/repository/profile_repository.dart';
import 'package:everli_client/features/app/presentation/todo/bloc/assignment_bloc.dart';
import 'package:everli_client/features/app/presentation/todo/repository/assignment_repository.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> registerDependencies() async {
  //* Firebase
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  sl.registerSingleton<FirebaseAuth>(auth);
  sl.registerSingleton<FirebaseStorage>(storage);

  //* Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //* Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  //* Register Logger
  sl.registerSingleton<Logger>(Logger());

  //* Core
  //* Register AppUserRepository
  sl.registerLazySingleton<AppUserRepository>(() => AppUserRepository(
        logger: sl<Logger>(),
      ));
  //* Register AppUserCubit
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit(
        sharedPreferences: sl<SharedPreferences>(),
        appUserRepository: sl<AppUserRepository>(),
        firebaseAuth: sl<FirebaseAuth>(),
        logger: sl<Logger>(),
      ));

  //* Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(
        firebaseAuth: sl<FirebaseAuth>(),
        logger: sl<Logger>(),
      ));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(
        logger: sl<Logger>(),
      ));
  sl.registerLazySingleton<AssignmentRepository>(() => AssignmentRepository(
        logger: sl<Logger>(),
      ));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository(
        logger: sl<Logger>(),
      ));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(
        logger: sl<Logger>(),
      ));

  //* ViewModels
  //* Register AuthBloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        authRepository: sl<AuthRepository>(),
        appUserCubit: sl<AppUserCubit>(),
        firebaseAuth: sl<FirebaseAuth>(),
        logger: sl<Logger>(),
      ));
  sl.registerFactory<HomeBloc>(() => HomeBloc(
        appUserCubit: sl<AppUserCubit>(),
        homeRepository: sl<HomeRepository>(),
        logger: sl<Logger>(),
      ));
  sl.registerFactory<AssignmentBloc>(() => AssignmentBloc());
  sl.registerFactory<ChatBloc>(() => ChatBloc());
  sl.registerFactory<ProfileBloc>(() => ProfileBloc());
}
