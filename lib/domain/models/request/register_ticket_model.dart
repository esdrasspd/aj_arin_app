import 'dart:io';

class RegisterTicketModel {
  final String title;
  final String description;
  final String ubication;
  final String reference;
  final File image;
  final String dpi;
  final String typeTicket;

  RegisterTicketModel({
    required this.title,
    required this.description,
    required this.ubication,
    required this.reference,
    required this.image,
    required this.dpi,
    required this.typeTicket,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': title,
      'descripcion': description,
      'ubicacion': ubication,
      'imagen': image,
      'dpiCliente': dpi,
      'tipoTicketId': typeTicket,
      'referencia': reference
    };
  }
}
