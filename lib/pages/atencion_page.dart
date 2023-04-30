import 'package:flutter/material.dart';

class AtencionPage extends StatefulWidget {
  const AtencionPage({super.key});

  @override
  State<AtencionPage> createState() => _AtencionPageState();
}

class _AtencionPageState extends State<AtencionPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 13),
        Text('Nueva atencion'),
      ],
    );
  }
}
