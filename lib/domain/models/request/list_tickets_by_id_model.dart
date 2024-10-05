class ListTicketsByIdModel {
  final String dpi;
  ListTicketsByIdModel({required this.dpi});

  Map<String, dynamic> toJson() {
    return {'dpi': dpi};
  }
}
