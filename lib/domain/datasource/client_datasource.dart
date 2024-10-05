import 'package:tickets_app/domain/models/request/register_client_model.dart';
import 'package:tickets_app/domain/models/response/administrative_model.dart';

abstract class ClientDatasource {
  Future<AdministrativeModel> registerClient(
      RegisterClientModel registerClientModel);
}
