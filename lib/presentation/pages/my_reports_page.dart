import 'package:flutter/material.dart';
import 'package:AjArin/data/datasource/ticket_datasource_impl.dart';
import 'package:AjArin/data/repositories/ticket_repository_impl.dart';
import 'package:AjArin/domain/models/mapper/report_mapper_model.dart';
import 'package:AjArin/domain/models/request/list_tickets_by_id_model.dart';
import 'package:AjArin/domain/repositories/ticket_repository.dart';
import 'package:AjArin/presentation/pages/dashboard_page.dart';
import 'package:AjArin/presentation/pages/report_info_page.dart';
import 'package:AjArin/presentation/pages/starter_page.dart';
import 'package:AjArin/presentation/widgets/custom_bottom_navigation_bar.dart';

class MyReportsPage extends StatefulWidget {
  final String dpi;
  final String name;
  const MyReportsPage({Key? key, required this.dpi, required this.name})
      : super(key: key);

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  int _currentIndex = 0;
  late final TicketRepository _ticketRepository;

  @override
  void initState() {
    super.initState();
    _ticketRepository =
        TicketRepositoryImpl(ticketDatasource: TicketDataSourceImpl());
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
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StarterPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reportes'),
      ),
      body: FutureBuilder<List<ReportMapperModel>>(
        future:
            _ticketRepository.getReports(ListTicketsByIdModel(dpi: widget.dpi)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay reportes disponibles'));
          } else {
            final reports = snapshot.data!;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  title: Text(report.titulo),
                  subtitle: Text('Estado: ${report.estado}\n'
                      'Descripción: ${report.descripcion}'),
                  trailing: Text(
                    'Fecha: ${report.fechaCreacion}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportInfoPage(
                            dpi: widget.dpi,
                            id: report.id.toString(),
                            name: widget.name),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
