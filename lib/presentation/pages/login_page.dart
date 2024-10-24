import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:AjArin/data/datasource/login_datasource_impl.dart';
import 'package:AjArin/data/repositories/login_repository_impl.dart';
import 'package:AjArin/domain/models/request/login_model.dart';
import 'package:AjArin/domain/repositories/login_repository.dart';
import 'package:AjArin/presentation/pages/dashboard_page.dart';
import 'package:AjArin/presentation/pages/register_page.dart';
import 'package:AjArin/presentation/widgets/build_text_field.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:AjArin/presentation/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _dpiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final LoginRepository _loginRepository;

  @override
  void initState() {
    super.initState();
    _loginRepository =
        LoginRepositoryImpl(loginDataSource: LoginDataSourceImpl());
  }

  @override
  void dispose() {
    _dpiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _login() async {
    final loginModel = LoginModel(
      dpi: _dpiController.text,
      password: _passwordController.text,
    );
    final response = await _loginRepository.login(loginModel);
    return {
      'code': response.code,
      'message': response.message,
    };
  }

  // Función para mostrar un diálogo de carga
  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Función para cerrar el diálogo de carga
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Icon(
                      Icons.phone_android,
                      size: 100,
                    ),
                    const SizedBox(height: 75),
                    Text(
                      'Aj Arin',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BuildTextField(
                      labelText: 'DPI',
                      controller: _dpiController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su DPI';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      labelText: 'Contraseña',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        onTap: () async {
                          // Mostrar el círculo de carga
                          showLoadingDialog(context);
                          final result = await _login();

                          // Ocultar el círculo de carga
                          hideLoadingDialog(context);

                          if (result['code'] == '200') {
                            String token = result['message'] ?? '';
                            if (!JwtDecoder.isExpired(token)) {
                              Map<String, dynamic> decodedToken =
                                  JwtDecoder.decode(token);

                              String dpi = decodedToken['dpi'];
                              String name = decodedToken['name'];

                              if (mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardPage(
                                              dpi: dpi,
                                              name: name,
                                            )));
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Usuario o contraseña incorrectos'),
                                  ),
                                );
                              }
                            }
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message'] ??
                                      'Error al iniciar sesión'),
                                ),
                              );
                            }
                          }
                        },
                        buttonText: 'Iniciar sesión'),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                          },
                          child: const Text(
                            ' Regístrarse',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
