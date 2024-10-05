import 'dart:convert'; // Necesario para base64Decode
import 'package:flutter/material.dart';
import 'package:tickets_app/data/datasource/ticket_datasource_impl.dart';
import 'package:tickets_app/data/repositories/ticket_repository_impl.dart';
import 'package:tickets_app/domain/repositories/ticket_repository.dart';
import 'package:tickets_app/domain/models/mapper/report_by_id_mapper_model.dart';
import 'package:tickets_app/presentation/pages/my_reports_page.dart';
import 'package:tickets_app/presentation/widgets/build_text_field.dart'; // Asegúrate de tener esta entidad

class ReportInfoPage extends StatefulWidget {
  final String dpi;
  final String id;
  final String name;

  const ReportInfoPage(
      {Key? key, required this.dpi, required this.id, required this.name})
      : super(key: key);

  @override
  State<ReportInfoPage> createState() => _ReportInfoPageState();
}

class _ReportInfoPageState extends State<ReportInfoPage> {
  late final TicketRepository _ticketRepository;
  ReportByIdMapperModel? _ticket;

  @override
  void initState() {
    super.initState();
    _ticketRepository =
        TicketRepositoryImpl(ticketDatasource: TicketDataSourceImpl());
  }

  // Future para obtener el reporte por ID
  Future<ReportByIdMapperModel?> _getReport() async {
    final ticket = await _ticketRepository.getReportById(widget.id);
    _ticket = ticket; // Guardamos el ticket en la variable local
    return ticket;
  }

  Future<void> _confirmDeleteReport(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar reporte'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este reporte?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Eliminar el reporte
      await _ticketRepository.deleteReport(widget.id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyReportsPage(dpi: widget.dpi, name: widget.name)),
      );
    }
  }

  Future<void> _showEditModal(
      BuildContext context, ReportByIdMapperModel ticket) async {
    final titleController = TextEditingController(text: ticket.title);
    final descriptionController =
        TextEditingController(text: ticket.description);
    final referenceController = TextEditingController(text: ticket.reference);

    String code = '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            bottom: bottomPadding,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Editar reporte',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              BuildTextField(
                labelText: 'Título',
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  } else if (value.length > 50) {
                    return 'El título no puede exceder los 50 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BuildTextField(
                labelText: 'Descripción',
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  } else if (value.length > 250) {
                    return 'La descripción no puede exceder los 250 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BuildTextField(
                labelText: 'Referencia de ubicación',
                controller: referenceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una referencia';
                  } else if (value.length > 250) {
                    return 'La referencia no puede exceder los 250 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Guardar cambios'),
                onPressed: () async {
                  // Guardar la edición
                  ticket.title = titleController.text;
                  ticket.description = descriptionController.text;
                  ticket.reference = referenceController.text;
                  final result = await _ticketRepository.updateReport(ticket);
                  code = result.code;
                  if (code == '200') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reporte actualizado'),
                      ),
                    );
                    Navigator.of(context).pop(); // Cerrar el modal
                    setState(() {}); // Refrescar la pantalla
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar el reporte: $code'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Función que retorna la imagen decodificada de base64
  Future<Image> _loadImage(String base64Image) async {
    final decodedBytes = base64Decode(base64Image);
    return Image.memory(decodedBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del reporte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              if (_ticket != null) {
                await _showEditModal(context, _ticket!);
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _confirmDeleteReport(context);
              }),
        ],
      ),
      body: FutureBuilder<ReportByIdMapperModel?>(
        future: _getReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar el reporte: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontró el reporte'));
          }

          final ticket = snapshot.data!;

          // Despliega la información del ticket
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Titulo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.description,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fecha de creación',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.creationDate,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Estado',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.status,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Referencia de ubicación',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ticket.reference,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<Image>(
                  future: _loadImage(ticket.imagePath),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (imageSnapshot.hasError) {
                      return const Center(
                          child: Text('Error al cargar la imagen'));
                    } else if (!imageSnapshot.hasData) {
                      return const Center(
                          child: Text('No se pudo cargar la imagen'));
                    }
                    // Despliega la imagen una vez cargada
                    return Center(
                      child: SizedBox(
                        width: 300,
                        height: 500,
                        child: imageSnapshot.data,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
