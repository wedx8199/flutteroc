import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/data/network/api_helper.dart';
import 'package:flutteroc/exceptions/exceptions.dart';
import 'package:flutteroc/repositories/repositories_utils.dart';

abstract class UserRepository {
  Future<ApiResponse<Map<String, dynamic>>> login(
      String username, String password);

  Future<ApiResponse<Map<String, dynamic>>> logout();
}

class UserRepositoryImpl extends UserRepository {
  final ApiHelper _apiHelper = ApiHelper();

  @override
  Future<ApiResponse<Map<String, dynamic>>> login(
      String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return ApiResponse.failure(
            AppException('Tên đăng nhập hoặc mật khẩu không hợp lệ.'));
      }
      final data = {
        "username": username,
        "pass": password,
      };
      final response = await _apiHelper.post('/public/loginapp', data);
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _apiHelper.get('/public/logoutapp');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }
}
