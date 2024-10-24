class RegisterClientModel {
  final String names;
  final String lastNames;
  final String dpi;
  final String residenceNeighborhood;
  final String birthDate;
  final String numberPhone;
  final String password;
  final String confirmPassword;
  final String deviceIdPushOtp;

  RegisterClientModel({
    required this.names,
    required this.lastNames,
    required this.dpi,
    required this.residenceNeighborhood,
    required this.birthDate,
    required this.numberPhone,
    required this.password,
    required this.confirmPassword,
    required this.deviceIdPushOtp,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombres': names,
      'apellidos': lastNames,
      'dpi': dpi,
      'territorioId': residenceNeighborhood,
      'fechaNacimiento': birthDate,
      'numeroTelefono': numberPhone,
      'password': password,
      'deviceIdPushOtp': deviceIdPushOtp,
    };
  }
}
