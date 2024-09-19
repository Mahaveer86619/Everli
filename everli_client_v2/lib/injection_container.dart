import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/repository/app_user_repository.dart';
import 'package:everli_client_v2/common/widgets/bottom_app_bar/bloc/navigation_bloc.dart';
import 'package:everli_client_v2/features/assignments/presentation/bloc/assignment_bloc.dart';
import 'package:everli_client_v2/features/auth/data/implementations/auth_repository_impl.dart';
import 'package:everli_client_v2/features/auth/data/sources/auth_data_source.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/authenticate_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/check_otp.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/create_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/register_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/reset_pass.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/send_pass_reset.dart';
import 'package:everli_client_v2/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:everli_client_v2/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:everli_client_v2/features/home/presentation/bloc/home_bloc.dart';
import 'package:everli_client_v2/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> registerDependencies() async {
  other();
  core();
  dataSources();
  repositories();
  useCases();
  blocs();
}

void other() async {
  //* Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //* Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  //* Register Logger
  sl.registerSingleton<Logger>(Logger());
}

void core() async {
  //* Register AppUserRepository
  sl.registerLazySingleton<AppUserRepository>(
    () => AppUserRepository(
      logger: sl<Logger>(),
    ),
  );
  //* Register AppUserCubit
  sl.registerLazySingleton<AppUserCubit>(
    () => AppUserCubit(
      sharedPreferences: sl<SharedPreferences>(),
      appUserRepository: sl<AppUserRepository>(),
      logger: sl<Logger>(),
    ),
  );
  //* Register NavigationBloc
  sl.registerLazySingleton<NavigationBloc>(
    () => NavigationBloc(),
  );
}

void dataSources() {
  // Register AuthDataSource
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(
      logger: sl(),
    ),
  );
}

void repositories() {
  // Register AppUserRepository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
      logger: sl(),
    ),
  );
}

void useCases() {
  // Register RegisterUserUseCase
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<AuthenticateUserUseCase>(
    () => AuthenticateUserUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<SendPassResetUseCase>(
    () => SendPassResetUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CheckOtpUseCase>(
    () => CheckOtpUseCase(
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton<ResetPassUseCase>(
    () => ResetPassUseCase(
      authRepository: sl(),
    ),
  );
}

void blocs() {
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      appUserCubit: sl(),
      logger: sl(),
      registerUserUseCase: sl(),
      createUserUseCase: sl(),
      authenticateUserUseCase: sl(),
      sendPassResetUseCase: sl(),
      checkOtpUseCase: sl(),
      resetPassUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<HomeBloc>(
    () => HomeBloc(
      appUserCubit: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<AssignmentBloc>(
    () => AssignmentBloc(
      appUserCubit: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<ChatBloc>(
    () => ChatBloc(
      appUserCubit: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<SettingsBloc>(
    () => SettingsBloc(
      appUserCubit: sl(),
      logger: sl(),
    ),
  );
}
