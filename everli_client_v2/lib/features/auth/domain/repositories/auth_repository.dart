import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
import 'package:everli_client_v2/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<DataState<AppUserModel>> registerUser(
    String username,
    String email,
    String password,
  );

  Future<DataState<String>> createUser(
    UserModel user,
    String token,
  );

  Future<DataState<AppUserModel>> authenticateUser(
    String email,
    String password,
  );

  Future<DataState<String>> sendOtp(
    String email,
  );

  Future<DataState<String>> checkOtp(
    String code,
    String email,
  );

  Future<DataState<String>> resetPass(
    String email,
    String password,
  );
}
