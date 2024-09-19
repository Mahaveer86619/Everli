import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/data/models/user_model.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class CreateUserUseCase
    implements UseCase<DataState<String>, CreateUserParams> {
  final AuthRepository authRepository;

  CreateUserUseCase({required this.authRepository});

  @override
  Future<DataState<String>> execute({required CreateUserParams params}) async {
    return await authRepository.createUser(
      params.user,
      params.token,
    );
  }
}

class CreateUserParams {
  final UserModel user;
  final String token;

  CreateUserParams({
    required this.user,
    required this.token,
  });
}
