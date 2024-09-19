import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
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
}
