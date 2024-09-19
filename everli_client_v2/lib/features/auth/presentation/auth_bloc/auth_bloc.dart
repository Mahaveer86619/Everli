import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/authenticate_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  final RegisterUserUseCase _registerUserUseCase;
  final AuthenticateUserUseCase _authenticateUserUseCase;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
    required RegisterUserUseCase registerUserUseCase,
    required AuthenticateUserUseCase authenticateUserUseCase,
  })  : _authenticateUserUseCase = authenticateUserUseCase,
        _registerUserUseCase = registerUserUseCase,
        _appUserCubit = appUserCubit,
        _logger = logger,
        super(const AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    // on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _registerUserUseCase.execute(
        params: RegisterUserParams(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );

      if (response is DataSuccess) {
        final user = response.data!;

        _logger.i('User: ${user.toJson()}');
        _logger.i('Token: ${response.data!.token}');
        _logger.i('Refresh token: ${response.data!.refreshToken}');

        await _appUserCubit.authenticateUser(user);

        emit(const Authenticated());
      } else {
        emit(AuthError(response.message!));
      }
    } catch (e) {
      _logger.e(e);
      emit(AuthError('Something went wrong'));
    }
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _authenticateUserUseCase.execute(
        params: AuthenticateUserParams(
          email: event.email,
          password: event.password,
        ),
      );

      if (response is DataSuccess) {
        final user = response.data!;

        await _appUserCubit.authenticateUser(user);

        _logger.i('Authenticated: ${response.message}');
        emit(const Authenticated());
      } else {
        _logger.i('Error: ${response.message}');
        emit(AuthError(response.message!));
      }
    } catch (e) {
      _logger.e(e);
      emit(AuthError('Something went wrong'));
    }
  }
}
