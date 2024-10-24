import 'package:AjArin/domain/datasource/client_datasource.dart';
import 'package:AjArin/domain/models/request/register_client_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';
import 'package:AjArin/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientDatasource clientDatasource;

  ClientRepositoryImpl({required this.clientDatasource});
  @override
  Future<AdministrativeModel> registerClient(
      RegisterClientModel registerClientModel) async {
    return await clientDatasource.registerClient(registerClientModel);
  }

  @override
  Future<AdministrativeModel> getTerritories() async {
    return await clientDatasource.getTerritories();
  }
}
