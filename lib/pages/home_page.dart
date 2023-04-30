import 'package:clinica_app/model/medico.dart';
import 'package:clinica_app/pages/atencion_page.dart';
import 'package:clinica_app/pages/historial_page.dart';
import 'package:clinica_app/pages/pendientes_page.dart';
import 'package:clinica_app/widgets/navbar_drawer.dart';
import 'package:clinica_app/model/enfermera.dart';
import 'package:clinica_app/pages/profile_page.dart';
import 'package:clinica_app/pages/register_page.dart';
import 'package:clinica_app/pages/search_page.dart';
import 'package:clinica_app/pages/triage_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Enfermera? enfermera;
  final Medico? medico;

  const HomePage({super.key, this.enfermera, this.medico});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String formattedDate =
      DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now());
  int index = 0;
  late final NavbarDrawer navbarPage;
  late final SearchPage searchPage;
  int hora = DateTime.now().hour - 5;
  late String saludo;
  String dni = '';
  String nhc = '';
  String paciente = '';

  @override
  void initState() {
    hora < 5 || hora > 18
        ? saludo = 'Buenas Noches'
        : hora > 4 || hora < 12
            ? saludo = 'Buenas Días'
            : 'Buenas Tardes';
    initializeDateFormatting('es-PE', '').then((value) =>
        formattedDate = DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now()));
    navbarPage = NavbarDrawer(
        enfermera: widget.enfermera,
        medico: widget.medico,
        currentIndex: (i) => setState(() {
              index = i;
              dni = '';
              nhc = '';
              paciente = '';
            }));
    searchPage = SearchPage(
        currentIndex: (i, dnis, nhcs, pacientes) => setState(() {
              index = i;
              dni = dnis;
              nhc = nhcs;
              paciente = pacientes;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listPages = [
      widget.enfermera != null ? searchPage : const PendientesPage(),
      widget.enfermera != null ? const RegisterPage() : const AtencionPage(),
      widget.enfermera != null
          ? TriagePage(dni: dni, nhc: nhc, paciente: paciente)
          : const HistorialPage(),
      const ProfilePage(),
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
                    onPressed: () {
                      // FocusScope.of(context).unfocus();
                      Scaffold.of(context).openDrawer();
                    }))),
        leadingWidth: 55,
        actions: [
          MaterialButton(
              minWidth: 0,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              child: const CircleAvatar(
                  maxRadius: 22,
                  // child: Image.asset('assets/profile.png', fit: BoxFit.cover)),
                  child: Icon(Icons.person_rounded, size: 30)),
              onPressed: () => true),
          const SizedBox(width: 13)
        ],
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
                      widget.enfermera != null
                          ? '$saludo, ${widget.enfermera!.nombres} ${widget.enfermera!.apellidoPaterno}'
                          : '$saludo, ${widget.medico!.nombres} ${widget.medico!.apellidoPaterno}',
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
