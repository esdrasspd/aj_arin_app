import 'package:tickets_app/domain/datasource/ticket_datasource.dart';
import 'package:tickets_app/domain/models/mapper/report_by_id_mapper_model.dart';
import 'package:tickets_app/domain/models/mapper/report_mapper_model.dart';
import 'package:tickets_app/domain/models/request/list_tickets_by_id_model.dart';
import 'package:tickets_app/domain/models/request/register_ticket_model.dart';
import 'package:tickets_app/domain/models/response/administrative_model.dart';
import 'package:tickets_app/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketDataSource ticketDatasource;

  TicketRepositoryImpl({required this.ticketDatasource});

  @override
  Future<AdministrativeModel> registerTicket(
      RegisterTicketModel registerTicketModel) async {
    return await ticketDatasource.registerTicket(registerTicketModel);
  }

  @override
  Future<List<ReportMapperModel>> getReports(
      ListTicketsByIdModel listTicketsByIdModel) async {
    return await ticketDatasource.getReports(listTicketsByIdModel);
  }

  @override
  Future<ReportByIdMapperModel> getReportById(String id) async {
    return await ticketDatasource.getReportById(id);
  }

  @override
  Future<AdministrativeModel> updateReport(
      ReportByIdMapperModel reportByIdMapperModel) async {
    return await ticketDatasource.updateReport(reportByIdMapperModel);
  }

  @override
  Future<AdministrativeModel> deleteReport(String id) async {
    return await ticketDatasource.deleteReport(id);
  }
}
