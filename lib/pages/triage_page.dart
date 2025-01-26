import 'package:clinica_app/controller/triaje_controller.dart';
import 'package:clinica_app/widgets/listview_build.dart';
import 'package:flutter/material.dart';

class TriagePage extends StatelessWidget {
  const TriagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Registrar Triaje',
          style: TextStyle(
              color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 15),
        ListviewBuild(
            medico: false, listaFuture: TriajeController().listarPendientes()),
      ],
    );
  }
}
