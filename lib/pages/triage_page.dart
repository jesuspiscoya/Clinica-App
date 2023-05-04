import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/listview_build.dart';
import 'package:flutter/material.dart';

class TriagePage extends StatefulWidget {
  const TriagePage({super.key});

  @override
  State<TriagePage> createState() => _TriagePageState();
}

class _TriagePageState extends State<TriagePage> {
  GlobalKey<FormState> formKeyTriaje = GlobalKey<FormState>();
  GlobalKey<FormFieldState> keyDni = GlobalKey<FormFieldState>();
  TextEditingController dniController = TextEditingController();
  TextEditingController nhcController = TextEditingController();
  TextEditingController pacienteController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController tallaController = TextEditingController();
  TextEditingController temperaturaController = TextEditingController();
  TextEditingController presionController = TextEditingController();
  bool load = false;

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
        ListviewBuild(medico: false, future: TriajeDao().listarPendientes()),
      ],
    );
  }
}
