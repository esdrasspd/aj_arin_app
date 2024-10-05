import 'package:flutter/material.dart';
import 'package:tickets_app/data/datasource/client_datasource_impl.dart';
import 'package:tickets_app/data/repositories/client_repository_impl.dart';
import 'package:tickets_app/domain/models/request/register_client_model.dart';
import 'package:tickets_app/domain/repositories/client_repository.dart';
import 'package:tickets_app/presentation/widgets/build_text_field.dart';
import 'package:tickets_app/presentation/widgets/custom_button.dart';
import 'package:tickets_app/presentation/widgets/date_picker_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Llave del formulario

  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _dpiController = TextEditingController();
  final TextEditingController _residenceNeighborhoodController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _numberPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final ClientRepository _clientRepository;
  bool _isLoading = false; // Estado de carga

  @override
  void initState() {
    super.initState();
    _clientRepository =
        ClientRepositoryImpl(clientDatasource: ClientDataSourceImpl());
  }

  @override
  void dispose() {
    _namesController.dispose();
    _lastNamesController.dispose();
    _dpiController.dispose();
    _residenceNeighborhoodController.dispose();
    _birthDateController.dispose();
    _numberPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String> _registerClient() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Si el formulario es válido
      setState(() {
        _isLoading = true;
      });

      final registerClientModel = RegisterClientModel(
        names: _namesController.text,
        lastNames: _lastNamesController.text,
        dpi: _dpiController.text,
        residenceNeighborhood: _residenceNeighborhoodController.text,
        birthDate: _birthDateController.text,
        numberPhone: _numberPhoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      final result =
          await _clientRepository.registerClient(registerClientModel);

      setState(() {
        _isLoading = false;
      });

      return result.code;
    } else {
      return '400'; // Código de error en caso de validación fallida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Registro'),
      ),
      backgroundColor: Colors.grey[200],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        BuildTextField(
                          labelText: 'Nombre',
                          controller: _namesController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su nombre';
                            } else if (value.length > 50) {
                              return 'El nombre no puede exceder los 50 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        BuildTextField(
                          labelText: 'Apellido',
                          controller: _lastNamesController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su apellido';
                            } else if (value.length > 50) {
                              return 'El apellido no puede exceder los 50 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        BuildTextField(
                          labelText: 'Número de DPI',
                          controller: _dpiController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su DPI';
                            } else if (value.length != 13) {
                              return 'El DPI debe tener 13 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildDropdownField(),
                        const SizedBox(height: 15),
                        DatePickerField(
                          controller: _birthDateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        BuildTextField(
                          labelText: 'Número de teléfono',
                          controller: _numberPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su número de teléfono';
                            } else if (value.length != 8) {
                              return 'El número de teléfono debe tener 8 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        BuildTextField(
                          labelText: 'Contraseña',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese una contraseña';
                            } else if (value.length < 4 || value.length > 50) {
                              return 'La contraseña debe tener entre 4 y 50 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        BuildTextField(
                          labelText: 'Confirmar contraseña',
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomButton(
                            onTap: () async {
                              String code = await _registerClient();
                              if (code == '200') {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Registro exitoso'),
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
                            },
                            buttonText: 'Registrarse',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Barrio de residencia',
              labelStyle: TextStyle(color: Colors.teal.shade900),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            items: const [
              DropdownMenuItem(
                child: Text('Zona 1'),
                value: '1',
              ),
              // Agrega más opciones aquí
            ],
            onChanged: (value) {
              _residenceNeighborhoodController.text = value ?? '';
            },
          ),
        ),
      ),
    );
  }
}
