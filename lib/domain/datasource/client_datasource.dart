import 'package:AjArin/domain/models/request/register_client_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';

abstract class ClientDatasource {
  Future<AdministrativeModel> registerClient(
      RegisterClientModel registerClientModel);

  Future<AdministrativeModel> getTerritories();
}
