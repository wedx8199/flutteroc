import 'package:flutteroc/exceptions/exception.dart';

abstract class Response<T> {}

class Result<T> extends Response<T> {
  final T data;

  Result(this.data);
}

class Error<T> extends Response<T> {
  final AppException exception;

  Error(this.exception);
}
