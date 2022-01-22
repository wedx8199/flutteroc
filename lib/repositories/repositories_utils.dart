import 'dart:convert';

import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/exceptions/exceptions.dart';
import 'package:flutteroc/exceptions/unhandled_exception.dart';

class RepositoriesUtil {
  static ApiResponse<T> handleError<T>(Object error) {
    if (error is AppException) {
      print('Handled Error: ${error.message}');
      var message = error.message;
      try {
        message = jsonDecode(message)['message'];
      } catch (e) {
        print(e);
      }
      return ApiResponse.failure(AppException(message));
    } else {
      print('Unhandled Error: $error');
      return ApiResponse.failure(UnhandledException('An error occurred.'));
    }
  }
}
