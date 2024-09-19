import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/constants/app_constants.dart';
import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/resources/helpers.dart';
import 'package:everli_client_v2/features/auth/data/models/user_model.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/authenticate_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/check_otp.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/create_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/register_user.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/reset_pass.dart';
import 'package:everli_client_v2/features/auth/domain/usecases/send_pass_reset.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  final RegisterUserUseCase _registerUserUseCase;
  final CreateUserUseCase _createUserUseCase;
  final AuthenticateUserUseCase _authenticateUserUseCase;
  final SendPassResetUseCase _sendPassResetUseCase;
  final CheckOtpUseCase _checkOtpUseCase;
  final ResetPassUseCase _resetPassUseCase;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
    required RegisterUserUseCase registerUserUseCase,
    required CreateUserUseCase createUserUseCase,
    required AuthenticateUserUseCase authenticateUserUseCase,
    required SendPassResetUseCase sendPassResetUseCase,
    required CheckOtpUseCase checkOtpUseCase,
    required ResetPassUseCase resetPassUseCase,
  })  : _authenticateUserUseCase = authenticateUserUseCase,
        _registerUserUseCase = registerUserUseCase,
        _createUserUseCase = createUserUseCase,
        _sendPassResetUseCase = sendPassResetUseCase,
        _checkOtpUseCase = checkOtpUseCase,
        _resetPassUseCase = resetPassUseCase,
        _appUserCubit = appUserCubit,
        _logger = logger,
        super(const AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SendPassResetOtpEvent>(_verifAndSentOtp);
    on<VerifyOtpEvent>(_verifOtp);
    on<ResetPassEvent>(_resetPass);
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final response = await _registerUserUseCase.execute(
        params: RegisterUserParams(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );

      if (response is DataSuccess) {
        final user = response.data!;

        final profileResponse = await _createUserUseCase.execute(
          params: CreateUserParams(
            user: UserModel(
              id: "",
              name: event.username,
              email: event.email,
              avatarUrl: defaultAvatarUrl,
              bio: getRandomDefaultBio(),
              skills: getRandomSkills(),
              createdAt: DateTime.now().toIso8601String(),
              updatedAt: DateTime.now().toIso8601String(),
            ),
            token: user.token,
          ),
        );

        if (profileResponse is DataSuccess) {
          await _appUserCubit.authenticateUser(user);
          emit(const Authenticated());
        } else {
          _logger.i('Error: ${profileResponse.message}');
        }
      } else {
        _logger.i('Error: ${response.message}');
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
      emit(const AuthLoading());
      final response = await _authenticateUserUseCase.execute(
        params: AuthenticateUserParams(
          email: event.email,
          password: event.password,
        ),
      );

      if (response is DataSuccess) {
        final user = response.data!;

        await _appUserCubit.authenticateUser(user);

        emit(const Authenticated());
      } else {
        _logger.i('Error: ${response.message}');
      }
    } catch (e) {
      _logger.e(e);
      emit(AuthError('Something went wrong'));
    }
  }

  Future<void> _verifAndSentOtp(
    SendPassResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final response = await _sendPassResetUseCase.execute(
        params: SendPassResetParams(
          email: event.email,
        ),
      );

      if (response is DataSuccess) {
        emit(SentPassResetCode(event.email));
      } else {
        _logger.i('Error: ${response.message}');
      }
    } catch (e) {
      _logger.e(e);
      emit(PassResetCodeError('Something went wrong'));
    }
  }

  Future<void> _verifOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final response = await _checkOtpUseCase.execute(
        params: CheckOtpUseCaseParams(
          code: event.code,
          email: event.email,
        ),
      );

      if (response is DataSuccess) {
        emit(const VerifiedPassResetCode());
      } else {
        _logger.i('Error: ${response.message}');
      }
    } catch (e) {
      _logger.e(e);
      emit(PassResetCodeError('Something went wrong'));
    }
  }

  Future<void> _resetPass(
    ResetPassEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final response = await _resetPassUseCase.execute(
        params: ResetPassParams(
          password: event.password,
          email: event.email,
        ),
      );

      if (response is DataSuccess) {
        emit(const PasswordResetSuccess());
      } else {
        _logger.i('Error: ${response.message}');
      }
    } catch (e) {
      _logger.e(e);
      emit(PassResetCodeError('Something went wrong'));
    }
  }
}
