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
      children: const [
        SizedBox(height: 13),
        Text('Lista de Atenciones Pendientes'),
      ],
    );
  }
}
