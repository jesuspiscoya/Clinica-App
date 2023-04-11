import 'package:clinica_app/pages/navbar_page.dart';
import 'package:flutter/material.dart';

class TriagePAge extends StatefulWidget {
  const TriagePAge({super.key});

  @override
  State<TriagePAge> createState() => _TriagePAgeState();
}

class _TriagePAgeState extends State<TriagePAge> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [SizedBox(height: 13), Text('Registrar Triaje')],
    );
  }
}
