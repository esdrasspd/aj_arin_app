class ReportByIdMapperModel {
  final String id;
  String title;
  String description;
  String reference;
  final String status;
  final String creationDate;
  final String imagePath;

  ReportByIdMapperModel({
    required this.id,
    required this.title,
    required this.description,
    required this.reference,
    required this.status,
    required this.creationDate,
    required this.imagePath,
  });

  factory ReportByIdMapperModel.fromJson(Map<String, dynamic> json) {
    return ReportByIdMapperModel(
      id: json['Id'],
      title: json['Titulo'],
      description: json['Descripcion'],
      reference: json['Referencia'],
      status: json['Estado'],
      creationDate: json['FechaCreacion'],
      imagePath: json['imageBase64String'],
    );
  }
}
