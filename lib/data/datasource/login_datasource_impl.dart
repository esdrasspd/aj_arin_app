import 'package:AjArin/data/utils/api_config.dart';
import 'package:AjArin/domain/datasource/login_data_source.dart';
import 'package:AjArin/domain/models/request/login_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';
import 'package:dio/dio.dart';

class LoginDataSourceImpl implements LoginDataSource {
  @override
  Future<AdministrativeModel> login(LoginModel request) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        '${ApiConfig.BASE_URL}${ApiConfig.loginApp}',
        queryParameters: request.toJson(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        return AdministrativeModel(
          code: responseData['code'] ?? '000',
          message: responseData['message'] ?? 'No message received',
        );
      } else {
        return AdministrativeModel(
          code: response.statusCode.toString(),
          message: 'Error: ${response.statusMessage}',
        );
      }
    } catch (e) {
      return AdministrativeModel(
        code: "000",
        message: 'Exception: ${e.toString()}',
      );
    }
  }
}
