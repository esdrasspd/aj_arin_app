class ReportMapperModel {
  final int id;
  final String titulo;
  final String descripcion;
  final String estado;
  final DateTime fechaCreacion;

  ReportMapperModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fechaCreacion,
  });

  factory ReportMapperModel.fromJson(Map<String, dynamic> json) {
    return ReportMapperModel(
      id: json['Id'],
      titulo: json['Titulo'],
      descripcion: json['Descripcion'],
      estado: json['Estado'],
      fechaCreacion: DateTime.parse(json['FechaCreacion']),
    );
  }
}
