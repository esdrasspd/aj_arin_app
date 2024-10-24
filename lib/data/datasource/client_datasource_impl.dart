import 'package:dio/dio.dart';
import 'package:AjArin/data/utils/api_config.dart';
import 'package:AjArin/domain/datasource/client_datasource.dart';
import 'package:AjArin/domain/models/request/register_client_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';

class ClientDataSourceImpl implements ClientDatasource {
  @override
  Future<AdministrativeModel> registerClient(
      RegisterClientModel registerClientModel) async {
    try {
      // Validar contraseña y confirmar contraseña
      if (registerClientModel.password != registerClientModel.confirmPassword) {
        return AdministrativeModel(
          code: "000",
          message: "Las contraseñas no coinciden",
        );
      }

      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'Nombres': registerClientModel.names,
        'Apellidos': registerClientModel.lastNames,
        'Dpi': registerClientModel.dpi,
        'TerritorioId': registerClientModel.residenceNeighborhood,
        'FechaNacimiento': registerClientModel.birthDate,
        'NumeroTelefono': registerClientModel.numberPhone,
        'Password': registerClientModel.password,
        'DeviceIdPushOtp': registerClientModel.deviceIdPushOtp,
      });

      Response response = await dio.post(
        '${ApiConfig.BASE_URL}${ApiConfig.registerClient}',
        data: formData,
      );
      // Manejar la respuesta según el código de estado HTTP
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        return AdministrativeModel(
          code: responseData['code'] ?? '000',
          message: responseData['message'] ?? 'No message received',
        );
      } else {
        // Manejo de respuestas no exitosas
        return AdministrativeModel(
          code: response.statusCode.toString(),
          message: 'Error: ${response.statusMessage}',
        );
      }
    } catch (e) {
      // Manejo de excepciones
      return AdministrativeModel(
        code: "000",
        message: 'Exception: ${e.toString()}',
      );
    }
  }

  @override
  Future<AdministrativeModel> getTerritories() async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(
        '${ApiConfig.BASE_URL}${ApiConfig.getTerritories}',
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
