import 'dart:core';

class AppException implements Exception {
  final String message;

  AppException({this.message = 'Lỗi hệ thống, vui lòng thử lại.'});
}
