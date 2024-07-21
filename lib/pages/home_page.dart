import 'package:clinica_app/model/personal.dart';
import 'package:clinica_app/pages/atencion_page.dart';
import 'package:clinica_app/pages/historial_page.dart';
import 'package:clinica_app/pages/pendientes_page.dart';
import 'package:clinica_app/widgets/navbar_drawer.dart';
import 'package:clinica_app/pages/profile_page.dart';
import 'package:clinica_app/pages/register_page.dart';
import 'package:clinica_app/pages/triage_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Personal personal;

  const HomePage({super.key, required this.personal});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String formattedDate =
      DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now());
  int index = 0;
  late final NavbarDrawer navbarPage;
  late final AtencionPage atencionPage;
  int hora = DateTime.now().hour;
  late String saludo;
  String dni = '', nhc = '', paciente = '';

  @override
  void initState() {
    hora > 4 && hora < 12
        ? saludo = 'Buenas Días'
        : hora > 11 && hora < 19
            ? saludo = 'Buenas Tardes'
            : saludo = 'Buenas Noches';
    initializeDateFormatting('es-PE', '').then((value) =>
        formattedDate = DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now()));
    navbarPage = NavbarDrawer(
        personal: widget.personal,
        currentIndex: (i) => setState(() {
              index = i;
              dni = '';
              nhc = '';
              paciente = '';
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listPages = [
      widget.personal.tipoPersonal == '1'
          ? PendientesPage(codMedico: widget.personal.codigo)
          : AtencionPage(codEnfermera: widget.personal.codigo),
      widget.personal.tipoPersonal == '1'
          ? HistorialPage(codMedico: widget.personal.codigo)
          : const RegisterPage(),
      widget.personal.tipoPersonal == '1'
          ? const SizedBox()
          : const TriagePage(),
      ProfilePage(personal: widget.personal),
    ];

    return Scaffold(
      drawer: navbarPage,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 2.7,
                colors: <Color>[
                  Color(0xFF4284DB),
                  Color(0xFF29EAC4),
                ],
              ),
            ),
            child: const Text('Juan Pablo II')),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
        backgroundColor: const Color(0xFF131935),
        leading: Builder(
            builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: MaterialButton(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.sort_rounded,
                        color: Colors.white, size: 33),
                    onPressed: () => Scaffold.of(context).openDrawer()))),
        leadingWidth: 55,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  color: Color(0xFF131935)),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '$saludo, ${widget.personal.nombres} ${widget.personal.apellidoPaterno}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.white,
                          height: 1.3,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            listPages[index]
          ],
        ),
      ),
    );
  }
}
