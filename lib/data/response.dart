import 'package:flutteroc/exceptions/exceptions.dart';

class ApiResponse<T> {
  final Status status;
  final T? data;
  final AppException? exception;

  ApiResponse.success(this.data)
      : status = Status.SUCCESS,
        exception = null;

  ApiResponse.failure(this.exception)
      : status = Status.FAILURE,
        data = null;

  bool isSuccess() => status == Status.SUCCESS;

  bool isFailure() => status == Status.FAILURE;
}

enum Status { SUCCESS, FAILURE }
