import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class SendPassResetUseCase implements UseCase<DataState<String>, SendPassResetParams> {
  final AuthRepository authRepository;

  SendPassResetUseCase({required this.authRepository});
  
  @override
  Future<DataState<String>> execute({required SendPassResetParams params}) async {
    return await authRepository.sendOtp(
      params.email,
    );
  }
}

class SendPassResetParams {
  final String email;

  SendPassResetParams({
    required this.email,
  });
}