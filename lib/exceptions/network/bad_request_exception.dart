import '../app_exception.dart';

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message);
}