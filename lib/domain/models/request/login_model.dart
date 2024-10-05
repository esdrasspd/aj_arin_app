class LoginModel {
  final String dpi;
  final String password;

  LoginModel({
    required this.dpi,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'dpi': dpi,
      'password': password,
    };
  }
}