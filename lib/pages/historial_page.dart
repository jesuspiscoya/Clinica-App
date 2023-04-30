import 'package:flutter/material.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 13),
        Text('Historial de Pacientes Atendidos'),
      ],
    );
  }
}
