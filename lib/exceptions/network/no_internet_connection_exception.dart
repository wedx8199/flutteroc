import '../app_exception.dart';

class NoInternetConnectionException extends AppException {
  NoInternetConnectionException(String message) : super(message);
}
