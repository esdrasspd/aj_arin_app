import 'package:AjArin/domain/models/request/login_model.dart';
import 'package:AjArin/domain/models/response/administrative_model.dart';

abstract class LoginDataSource {
  Future<AdministrativeModel> login(LoginModel registerClientModel);
}
