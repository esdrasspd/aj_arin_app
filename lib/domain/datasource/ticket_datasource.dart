import 'package:AjArin/domain/models/mapper/report_by_id_mapper_model.dart';
import 'package:AjArin/domain/models/mapper/report_mapper_model.dart';
import 'package:AjArin/domain/models/request/list_tickets_by_id_model.dart';
import 'package:AjArin/domain/models/request/register_ticket_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';

abstract class TicketDataSource {
  Future<AdministrativeModel> registerTicket(
      RegisterTicketModel registerTicketModel);

  Future<List<ReportMapperModel>> getReports(
      ListTicketsByIdModel listTicketsByIdModel);

  Future<ReportByIdMapperModel> getReportById(String id);

  Future<AdministrativeModel> deleteReport(String id);

  Future<AdministrativeModel> updateReport(
      ReportByIdMapperModel reportByIdMapperModel);
}
