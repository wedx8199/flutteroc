import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/data/network/api_helper.dart';
import 'package:flutteroc/repositories/repositories_utils.dart';

abstract class TableRepository {
  Future<ApiResponse<List>> getTables();
}

class TableRepositoryImpl extends TableRepository {
  final ApiHelper _apiHelper = ApiHelper();

  @override
  Future<ApiResponse<List>> getTables() async {
    try {
      final response = await _apiHelper.get('/public/loadtable');
      return ApiResponse.success(response);
    } catch (e) {
      return RepositoriesUtil.handleError(e);
    }
  }
}
