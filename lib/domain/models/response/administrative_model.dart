class AdministrativeModel {
  final String code;
  final String message;
  final String? token;

  AdministrativeModel({
    required this.code,
    required this.message,
    this.token,
  });
}
