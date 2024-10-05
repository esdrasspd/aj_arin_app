import 'package:tickets_app/domain/models/request/register_client_model.dart';
import 'package:tickets_app/domain/models/response/administrative_model.dart';

abstract class ClientRepository {
  Future<AdministrativeModel> registerClient(
      RegisterClientModel registerClientModel);
}
