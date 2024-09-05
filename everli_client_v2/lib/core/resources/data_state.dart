abstract class DataState<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  const DataState({
    this.data,
    this.message,
    this.statusCode,
  });
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data, String message) : super(data: data, message: message);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure(String error, int code) : super(message: error, statusCode: code);
}
