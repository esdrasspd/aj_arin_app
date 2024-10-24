import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:AjArin/data/utils/api_config.dart';
import 'package:AjArin/domain/datasource/ticket_datasource.dart';
import 'package:AjArin/domain/models/mapper/report_by_id_mapper_model.dart';
import 'package:AjArin/domain/models/mapper/report_mapper_model.dart';
import 'package:AjArin/domain/models/request/list_tickets_by_id_model.dart';
import 'package:AjArin/domain/models/request/register_ticket_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';

class TicketDataSourceImpl implements TicketDataSource {
  @override
  Future<AdministrativeModel> registerTicket(
      RegisterTicketModel registerTicketModel) async {
    try {
      if (registerTicketModel.title.isEmpty) {
        return AdministrativeModel(
            code: '000', message: 'El título es requerido');
      }

      if (registerTicketModel.title.length > 50) {
        return AdministrativeModel(
            code: '000', message: 'El título debe ser menor a 50 caracteres');
      }

      if (registerTicketModel.description.isEmpty) {
        return AdministrativeModel(
            code: '000', message: 'La descripción es requerida');
      }

      if (registerTicketModel.description.length > 250) {
        return AdministrativeModel(
            code: '000',
            message: 'La descripción debe ser menor a 200 caracteres');
      }

      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'titulo': registerTicketModel.title,
        'descripcion': registerTicketModel.description,
        'ubicacion': registerTicketModel.ubication,
        'dpiCliente': registerTicketModel.dpi,
        'tipoTicketId': registerTicketModel.typeTicket,
        'imagen': await MultipartFile.fromFile(
            registerTicketModel.image.path // Nombre del archivo que envías
            ),
        'referencia': registerTicketModel.reference,
      });

      Response response = await dio.post(
        '${ApiConfig.BASE_URL}${ApiConfig.registerTicket}',
        data: formData,
        options: Options(contentType: 'multipart/form-data'), // Importante
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

  @override
  Future<List<ReportMapperModel>> getReports(
      ListTicketsByIdModel listTicketsByIdModel) async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(
        '${ApiConfig.BASE_URL}${ApiConfig.getReports}',
        queryParameters: listTicketsByIdModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Extraer la cadena JSON del campo 'message'
        final List<dynamic> reportsJson = jsonDecode(data['message']);

        // Convertir la lista en una lista de ReportModel
        return reportsJson
            .map((json) => ReportMapperModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al obtener los reportes');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ReportByIdMapperModel> getReportById(String id) async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(
        '${ApiConfig.BASE_URL}${ApiConfig.getReportById}',
        queryParameters: {'id': id},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Extraer la cadena JSON del campo 'message'
        final reportJson = jsonDecode(data['message']);

        // Convertir el json en un ReportByIdMapperModel
        return ReportByIdMapperModel.fromJson(reportJson);
      } else {
        throw Exception('Error al obtener el reporte');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<AdministrativeModel> deleteReport(String id) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'id': id,
      });

      Response response = await dio.post(
        '${ApiConfig.BASE_URL}${ApiConfig.deleteReport}',
        data: formData,
        options: Options(contentType: 'multipart/form-data'), // Importante
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

  @override
  Future<AdministrativeModel> updateReport(
      ReportByIdMapperModel reportByIdMapperModel) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'id': reportByIdMapperModel.id,
        'titulo': reportByIdMapperModel.title,
        'descripcion': reportByIdMapperModel.description,
        'referencia': reportByIdMapperModel.reference,
      });

      Response response = await dio.post(
        '${ApiConfig.BASE_URL}${ApiConfig.updateReport}',
        data: formData,
        options: Options(contentType: 'multipart/form-data'), // Importante
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
