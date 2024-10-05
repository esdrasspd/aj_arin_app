import 'package:tickets_app/domain/models/request/login_model.dart';
import 'package:tickets_app/domain/models/response/administrative_model.dart';

abstract class LoginDataSource {
  Future<AdministrativeModel> login(LoginModel registerClientModel);
}
