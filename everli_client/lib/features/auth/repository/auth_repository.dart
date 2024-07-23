import 'package:everli_client/core/resources/data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseAuth});

  User? user;

  Future<DataState<String>> emailSignIn(String email, String password) async {
    try {
      final credentials = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        return const DataFailure("Authentication failed", -1);
      }
      user = credentials.user;
      return DataSuccess(user!.uid, "signed in with email");
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<String>> emailSignUp(String email, String password) async {
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credentials.user == null) {
        return const DataFailure("Authentication failed", -1);
      }
      user = credentials.user;
      return DataSuccess(user!.uid, "signed up with email");
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<String>> otpSignIn(String otp, String verificationId) async {
    try {
      final auth = FirebaseAuth.instance;
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final credentials = await auth.signInWithCredential(credential);
      if (credentials.user == null) {
        return const DataFailure("Authentication failed", -1);
      }
      user = credentials.user;
      return DataSuccess(user!.uid, "signed in with otp");
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<String>> googleAuth() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final credentials =
          await firebaseAuth.signInWithProvider(googleAuthProvider);
      if (credentials.user == null) {
        return const DataFailure("Authentication failed", -1);
      }
      user = credentials.user;
      return DataSuccess(user!.uid, "Signed in with google");
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
