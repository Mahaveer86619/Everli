part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}


// Auth Success
final class SignedIn extends AuthState {}

final class SignedUp extends AuthState {
  final String id;

  SignedUp(this.id);
}
final class CompletedProfile extends AuthState {}

final class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}


//! Phone Auth (do again)
final class FillingNumber extends AuthState {}

final class AuthOtpSent extends AuthState {
  final String message;

  AuthOtpSent(this.message);
}

final class FillingOtp extends AuthState {
  final String verificationId;

  FillingOtp(this.verificationId);
}
