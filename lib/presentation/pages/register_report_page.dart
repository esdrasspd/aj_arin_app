import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tickets_app/data/datasource/ticket_datasource_impl.dart';
import 'package:tickets_app/data/repositories/ticket_repository_impl.dart';
import 'package:tickets_app/domain/models/request/register_ticket_model.dart';
import 'package:tickets_app/domain/repositories/ticket_repository.dart';
import 'package:tickets_app/presentation/widgets/build_text_field.dart';
import 'package:tickets_app/presentation/widgets/custom_button.dart';

class RegisterReportPage extends StatefulWidget {
  final String dpi;
  final int typeTicket;
  final String descriptionTicket;

  const RegisterReportPage({
    Key? key,
    required this.dpi,
    required this.typeTicket,
    required this.descriptionTicket,
  }) : super(key: key);

  @override
  State<RegisterReportPage> createState() => _RegisterReportPageState();
}

class _RegisterReportPageState extends State<RegisterReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceController = TextEditingController();
  File? _imageFile;
  LatLng? _currentPosition;
  GoogleMapController? _mapController;

  late final TicketRepository _ticketRepository;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _ticketRepository =
        TicketRepositoryImpl(ticketDatasource: TicketDataSourceImpl());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mapController?.dispose();
    _imageFile?.delete();
    super.dispose();
  }

  Future<String> _registerTicket() async {
    final registerTicketModel = RegisterTicketModel(
      title: _titleController.text,
      description: _descriptionController.text,
      ubication: '${_currentPosition!.latitude},${_currentPosition!.longitude}',
      reference: _referenceController.text,
      dpi: widget.dpi,
      image: _imageFile!,
      typeTicket: widget.typeTicket.toString(),
    );
    final response =
        await _ticketRepository.registerTicket(registerTicketModel);
    return response.code;
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    if (await Permission.locationWhenInUse.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        // Verifica que no haya ya una imagen seleccionada
        if (_imageFile == null) {
          _imageFile = File(pickedFile.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solo puedes agregar una imagen.'),
            ),
          );
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes seleccionar al menos una imagen.'),
          ),
        );
        return;
      }

      String code = await _registerTicket();
      if (code == '200') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte registrado exitosamente'),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $code'),
            ),
          );
        }
      }
    }
  }

  bool _formIsValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _referenceController.text.isNotEmpty &&
        _currentPosition != null;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text('Nuevo Reporte - ${widget.descriptionTicket}'),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              // Formulario envolviendo los campos
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    labelText: 'Título',
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un título';
                      } else if (value.length > 50) {
                        return 'El título no puede exceder los 50 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  BuildTextField(
                    labelText: 'Descripción',
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      } else if (value.length > 250) {
                        return 'La descripción no puede exceder los 250 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Ubicación del Incidente:',
                    style: TextStyle(fontSize: 15),
                  ),
                  _currentPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 300,
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition!,
                              zoom: 15,
                            ),
                            myLocationEnabled: true,
                            onTap: (LatLng position) {
                              setState(() {
                                _currentPosition = position;
                              });
                            },
                          ),
                        ),
                  const SizedBox(height: 16),
                  BuildTextField(
                    labelText: 'Referencia de ubicación',
                    controller: _referenceController,
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
                  const Text(
                    'Imagen del Incidente:',
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  _imageFile == null
                      ? const Text('No se ha seleccionado imagen.')
                      : Image.file(
                          _imageFile!,
                          height: 150,
                        ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () async {
                      await _submitForm();
                    },
                    buttonText: 'Registrar reporte',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
