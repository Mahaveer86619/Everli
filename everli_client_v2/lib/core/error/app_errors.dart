abstract class Failure {
  final String message;
  final int? statusCode;

  Failure({required this.message, this.statusCode});
}

// 500 error
class ServerFailure extends Failure {
  ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.statusCode});
}

class InvalidToken extends Failure {
  InvalidToken({required super.message, super.statusCode});
}

class NoUserFoundError extends Failure {
  NoUserFoundError({required super.message, super.statusCode});
}

class UserAlreadyExistsError extends Failure {
  UserAlreadyExistsError({required super.message, super.statusCode});
}

class OtherError extends Failure {
  OtherError({required super.message, super.statusCode});
}

class UnknownError extends Failure {
  UnknownError({required super.message, super.statusCode});
}