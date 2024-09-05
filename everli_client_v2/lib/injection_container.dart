import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/repository/app_user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> registerDependencies() async {
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
        logger: sl<Logger>(),
      )); 
}
