import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/core/usecases/usecase.dart';
import 'package:everli_client_v2/features/auth/domain/repositories/auth_repository.dart';

class CheckOtpUseCase implements UseCase<DataState<String>, CheckOtpUseCaseParams> {
  final AuthRepository authRepository;

  CheckOtpUseCase({required this.authRepository});
  
  @override
  Future<DataState<String>> execute({required CheckOtpUseCaseParams params}) async {
    return await authRepository.checkOtp(
      params.code,
      params.email,
    );
  }
}

class CheckOtpUseCaseParams {
  final String code;
  final String email;

  CheckOtpUseCaseParams({
    required this.code,
    required this.email,
  });
}