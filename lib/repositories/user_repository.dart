import 'dart:convert';

import 'package:flutteroc/exceptions/exception.dart';
import 'package:flutteroc/network/response.dart';
import 'package:flutteroc/utils/constants.dart';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  Future<Response<Map<String, dynamic>>> login(
      String username, String password);

  Future<Response<Map<String, dynamic>>> logout();
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<Response<Map<String, dynamic>>> login(
      String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return Error(
            AppException(message: 'Tên đăng nhập hoặc mật khẩu không hợp lệ.'));
      }
      final data = {
        "username": username,
        "pass": password,
      };
      final response = await http.post(
          Uri.parse("${Constants.BASE_URL}/public/loginapp"),
          body: jsonEncode(data),
          headers: Constants.JSON_HEADER());
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Result(body);
      } else {
        return Error(AppException(message: '${body['message']}'));
      }
    } catch (e) {
      print(e);
      return Error(AppException());
    }
  }

  @override
  Future<Response<Map<String, dynamic>>> logout() async {
    try {
      final response = await http.get(
          Uri.parse("${Constants.BASE_URL}/public/logoutapp"),
          headers: Constants.JSON_HEADER());
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Result(body);
      } else {
        return Error(AppException(message: '${body['message']}'));
      }
    } catch (e) {
      print(e);
      return Error(AppException());
    }
  }
}
