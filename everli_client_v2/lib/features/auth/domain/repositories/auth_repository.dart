import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';

abstract class AuthRepository {
  Future<DataState<AppUserModel>> registerUser(
    String username,
    String email,
    String password,
  );

  Future<DataState<AppUserModel>> authenticateUser(
    String email,
    String password,
  );
}
