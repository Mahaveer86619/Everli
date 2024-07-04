import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/repository/app_user_repository.dart';
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
      ));

  //* ViewModels
  //* Register AuthBloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        authRepository: sl<AuthRepository>(),
        appUserCubit: sl<AppUserCubit>(),
        firebaseAuth: sl<FirebaseAuth>(),
        logger: sl<Logger>(),
      ));
}
