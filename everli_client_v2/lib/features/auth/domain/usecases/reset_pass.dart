
import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class ResetPassUseCase implements UseCase<DataState<String>, ResetPassParams> {
  final AuthRepository authRepository;

  ResetPassUseCase({required this.authRepository});
  
  @override
  Future<DataState<String>> execute({required ResetPassParams params}) async {
    return await authRepository.resetPass(
      params.email,
      params.password,
    );
  }
}

class ResetPassParams {
  final String email;
  final String password;

  ResetPassParams({
    required this.email,
    required this.password,
  });
}
