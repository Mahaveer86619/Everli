import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class AuthenticateUserUseCase implements UseCase<DataState<AppUserModel>, AuthenticateUserParams> {
  final AuthRepository authRepository;

  AuthenticateUserUseCase({required this.authRepository});
  
  @override
  Future<DataState<AppUserModel>> execute({required AuthenticateUserParams params}) async {
    return await authRepository.authenticateUser(
      params.email,
      params.password,
    );
  }
}

class AuthenticateUserParams {
  final String email;
  final String password;

  AuthenticateUserParams({
    required this.email,
    required this.password,
  });
}