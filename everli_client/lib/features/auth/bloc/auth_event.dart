part of 'auth_bloc.dart';

sealed class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

// Phone Auth
// go to phone auth screen
class OnPhoneAuthPressed extends AuthEvent {}

// go to otp auth screen
class OnOtpAuthPressed extends AuthEvent {
  final String phoneNumber;

  OnOtpAuthPressed({required this.phoneNumber});
}

class PhoneAuthEvent extends AuthEvent {
  final String verificationId;
  final String otp;

  PhoneAuthEvent({
    required this.verificationId,
    required this.otp,
  });
}

class GoogleAuthEvent extends AuthEvent {}

class OnCompleteProfilePressed extends AuthEvent {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String skills;

  OnCompleteProfilePressed({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.skills,
  });
}
