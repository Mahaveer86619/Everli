import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUseCase implements UseCase<DataState<AppUserModel>, RegisterUserParams> {
  final AuthRepository authRepository;

  RegisterUserUseCase({required this.authRepository});
  
  @override
  Future<DataState<AppUserModel>> execute({required RegisterUserParams params}) async {
    return await authRepository.registerUser(
      params.username,
      params.email,
      params.password,
    );
  }
}

class RegisterUserParams {
  final String username;
  final String email;
  final String password;

  RegisterUserParams({
    required this.username,
    required this.email,
    required this.password,
  });
}
