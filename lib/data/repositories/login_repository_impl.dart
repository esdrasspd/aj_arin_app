import 'package:tickets_app/domain/datasource/login_data_source.dart';
import 'package:tickets_app/domain/models/request/login_model.dart';
import 'package:tickets_app/domain/models/response/administrative_model.dart';
import 'package:tickets_app/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<AdministrativeModel> login(LoginModel request) async {
    return await loginDataSource.login(request);
  }
}
