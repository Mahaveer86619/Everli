import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
import 'package:everli_client_v2/features/auth/data/models/user_model.dart';
import 'package:everli_client_v2/features/auth/data/sources/auth_data_source.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final Logger logger;

  AuthRepositoryImpl({
    required this.authDataSource,
    required this.logger,
  });

  @override
  Future<DataState<AppUserModel>> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      final jsonData = await authDataSource.authenticateUser(
        email,
        password,
      );

      if (jsonData is DataSuccess) {
        final userModel = AppUserModel.fromJson(jsonData.data!);
        return DataSuccess(userModel, jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error authenticating user: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }

  @override
  Future<DataState<AppUserModel>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final jsonData = await authDataSource.registerUser(
        username,
        email,
        password,
      );

      if (jsonData is DataSuccess) {
        final userModel = AppUserModel.fromJson(jsonData.data!);

        return DataSuccess(userModel, jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error registering user: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }

  @override
  Future<DataState<String>> createUser(
    UserModel user,
    String token,
  ) async {
    try {
      final jsonData = await authDataSource.createUser(
        user,
        token,
      );

      if (jsonData is DataSuccess) {
        return DataSuccess("created user", jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error registering user: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }

  @override
  Future<DataState<String>> sendOtp(
    String email,
  ) async {
    try {
      final jsonData = await authDataSource.sendOtp(email);

      if (jsonData is DataSuccess) {
        return DataSuccess("Reset code sent", jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error validating email for reset password: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }

  @override
  Future<DataState<String>> checkOtp(
    String code,
    String email,
  ) async {
    try {
      final jsonData = await authDataSource.verifyOtp(code, email);

      if (jsonData is DataSuccess) {
        return DataSuccess("Code is Valid", jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error validating reset code: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }

  @override
  Future<DataState<String>> resetPass(String email, String password) async {
    try {
      final jsonData = await authDataSource.resetPass(
        email,
        password,
      );

      if (jsonData is DataSuccess) {
        return DataSuccess("Password updated", jsonData.message!);
      } else {
        return DataFailure(jsonData.message!, jsonData.statusCode!);
      }
    } catch (e) {
      logger.e("Error updating password: $e");
      return DataFailure('Somthing went wrong', -1);
    }
  }
}
