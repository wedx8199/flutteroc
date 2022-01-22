import 'package:flutteroc/data/network/api_helper.dart';
import 'package:flutteroc/data/response.dart';
import 'package:flutteroc/repositories/repositories_utils.dart';

abstract class OrderRepository {
  Future<ApiResponse<List>> getOrderDetails(int orderId);

  Future<ApiResponse> editOrder(int orderId, dynamic body);

  Future<ApiResponse> deleteOrder(int orderId);

  Future<ApiResponse> finishOrder(int tableId, dynamic body);
}

class OrderRepositoryImpl extends OrderRepository {
  final ApiHelper _apiHelper = ApiHelper();

  @override
  Future<ApiResponse<List>> getOrderDetails(int orderId) async {
    try {
      final response = await _apiHelper.get('/public/getbill/$orderId');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse> editOrder(int orderId, dynamic body) async {
    try {
      final response = await _apiHelper.post('/public/update/$orderId', body);
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse> deleteOrder(int orderId) async {
    try {
      final response = await _apiHelper.get('/public/delete/$orderId');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse> finishOrder(int tableId, body) async {
    try {
      final response = await _apiHelper.post('/public/checkout/$tableId', body);
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }
}
