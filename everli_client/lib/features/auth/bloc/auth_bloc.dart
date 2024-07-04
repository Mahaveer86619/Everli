import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:everli_client/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final AppUserCubit _appUserCubit;
  final FirebaseAuth _firebaseAuth;
  final Logger _logger;

  AuthBloc({
    required AuthRepository authRepository,
    required AppUserCubit appUserCubit,
    required FirebaseAuth firebaseAuth,
    required Logger logger,
  })  : _authRepository = authRepository,
        _appUserCubit = appUserCubit,
        _firebaseAuth = firebaseAuth,
        _logger = logger,
        super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<PhoneAuthEvent>(_onPhoneAuth);
    on<GoogleAuthEvent>(_onGoogleAuth);
    on<OnCompleteProfilePressed>(_onCompleteProfilePressed);

    on<OnPhoneAuthPressed>((_, emit) => emit(FillingNumber()));
    on<OnOtpAuthPressed>(_sendOtp);
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final res = await _authRepository.emailSignUp(
        event.email,
        event.password,
      );
      if (res is DataSuccess) {
        emit(SignedUp(res.data!));
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final res = await _authRepository.emailSignIn(
        event.email,
        event.password,
      );
      if (res is DataSuccess) {
        _appUserCubit.authenticateUser(res.data!).then((value) {
          emit(SignedIn());
        });
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> _onCompleteProfilePressed(
    OnCompleteProfilePressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      List<String> skills =
          event.skills.split(",").map((skill) => skill.trim()).toList();
      final id = const Uuid().v1();
      final user = AppUser(
        id: id,
        firebaseUid: event.id,
        username: event.username,
        email: event.email,
        avatarUrl: defaultAvatarUrl,
        bio: event.bio,
        skills: skills,
      );
      final res = await _appUserCubit.createUser(user);
      if (res) {
        emit(CompletedProfile());
      } else {
        emit(AuthError('Failed to create user'));
      }
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> _sendOtp(
    OnOtpAuthPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // error e
          _logger.e(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          // code sent to user
          emit(AuthOtpSent(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // error auto retrieval timeout
          _logger.e("Error auto retrieval timeout");
        },
      );
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> _onPhoneAuth(
    PhoneAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final res = await _authRepository.otpSignIn(
        event.verificationId,
        event.otp,
      );
      if (res is DataSuccess) {
        emit(AuthOtpSent('OTP sent'));
      } else {
        emit(AuthError('Sending OTP failed'));
      }
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> _onGoogleAuth(
    GoogleAuthEvent event,
    Emitter<AuthState> emit,
  ) async {}
}
