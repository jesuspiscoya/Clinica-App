import 'package:clinica_app/services/atencion_dao.dart';
import 'package:clinica_app/widgets/listview_build.dart';
import 'package:flutter/material.dart';

class PendientesPage extends StatefulWidget {
  const PendientesPage({super.key});

  @override
  State<PendientesPage> createState() => _PendientesPageState();
}

class _PendientesPageState extends State<PendientesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Atenciones Pendientes',
          style: TextStyle(
              color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
        ListviewBuild(medico: true, future: AtencionDao().listarPendientes())
      ],
    );
  }
}
