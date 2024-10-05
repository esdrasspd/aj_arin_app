import 'package:flutter/material.dart';
import 'package:tickets_app/data/utils/fade_animation.dart';
import 'package:tickets_app/presentation/pages/my_reports_page.dart';
import 'package:tickets_app/presentation/pages/register_report_page.dart';
import 'package:tickets_app/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:tickets_app/presentation/widgets/menu_slides.dart';

class DashboardPage extends StatefulWidget {
  final String name;
  final String dpi;
  const DashboardPage({Key? key, required this.name, required this.dpi})
      : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showWelcomeDialog();
  }

  int _currentIndex = 0;

  void _showWelcomeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '¡Bienvenido, ${widget.name}!',
              style: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              '¡Estimado vecino, le damos la bienvenida!\n\nRecuerde que aquí puede hacer sus reportes, estamos para servirle.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DashboardPage(name: widget.name, dpi: widget.dpi)),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyReportsPage(dpi: widget.dpi, name: widget.name)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      FadeAnimation(
                          1,
                          Text('¡Bienvenido, ${widget.name}!',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      FadeAnimation(
                        1,
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Seleccione el tipo de reporte que desea realizar',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 550,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              FadeAnimation(
                                  1,
                                  InkWell(
                                      child: const MenuSlides(
                                          description: 'Carretera',
                                          image: 'assets/images/carretera.jpg'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterReportPage(
                                              dpi: widget.dpi,
                                              typeTicket: 1,
                                              descriptionTicket: 'Carretera',
                                            ),
                                          ),
                                        );
                                      })),
                              FadeAnimation(
                                  1,
                                  InkWell(
                                      child: const MenuSlides(
                                          description:
                                              'Tubería de Agua Potable',
                                          image: 'assets/images/tuberia.jpeg'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterReportPage(
                                              dpi: widget.dpi,
                                              typeTicket: 2,
                                              descriptionTicket:
                                                  'Tubería de Agua Potable',
                                            ),
                                          ),
                                        );
                                      })),
                              FadeAnimation(
                                  1,
                                  InkWell(
                                      child: const MenuSlides(
                                          description: 'Basurero',
                                          image: 'assets/images/basurero.jpg'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterReportPage(
                                              dpi: widget.dpi,
                                              typeTicket: 3,
                                              descriptionTicket: 'Basurero',
                                            ),
                                          ),
                                        );
                                      })),
                              FadeAnimation(
                                  1,
                                  InkWell(
                                      child: const MenuSlides(
                                          description: 'Otros',
                                          image: 'assets/images/otros.jpg'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterReportPage(
                                              dpi: widget.dpi,
                                              typeTicket: 4,
                                              descriptionTicket: 'Otros',
                                            ),
                                          ),
                                        );
                                      })),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
