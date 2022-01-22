import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/data/network/api_helper.dart';
import 'package:flutteroc/repositories/repositories_utils.dart';

abstract class FoodRepository {
  Future<ApiResponse<dynamic>> addFood(
      int userId, int tableId, int foodId, int quantity, String note);

  Future<ApiResponse<List>> getFoods();

  Future<ApiResponse<List>> getCategory();
}

class FoodRepositoryImpl extends FoodRepository {
  final ApiHelper _apiHelper = ApiHelper();

  @override
  Future<ApiResponse> addFood(
      int userId, int tableId, int foodId, int quantity, String note) async {
    final body = {
      "id_user": userId,
      "id_food": foodId,
      "quantity": quantity,
      "note": note,
    };
    try {
      final response = await _apiHelper.post('/public/addorder/$tableId', body);
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse<List>> getFoods() async{
    try {
      final response = await _apiHelper.get('/public/showfood');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }

  @override
  Future<ApiResponse<List>> getCategory() async{
    try {
      final response = await _apiHelper.get('/first');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }
}
