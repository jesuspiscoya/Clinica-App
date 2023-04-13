import 'package:flutter/material.dart';

class DropdownForm extends StatefulWidget {
  final String label;
  String? value;

  DropdownForm({super.key, required this.label});

  @override
  State<DropdownForm> createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  List<String> itemsSexo = ['Masculino', 'Femenino'];
  List<String> itemsEstado = ['Soltero', 'Casado', 'Viudo', 'Divorciado'];
  List<String> itemsTipo = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> itemsDonacion = ['Sí', 'No'];
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownButtonFormField<String>(
        value: widget.value,
        decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.black12,
            labelText: widget.label,
            labelStyle: const TextStyle(height: 1.7, fontSize: 15),
            border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        items: identical(widget.label, 'Sexo')
            ? itemsSexo
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList()
            : identical(widget.label, 'Estado Civil')
                ? itemsEstado
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList()
                : identical(widget.label, 'Tip. Sangre')
                    ? itemsTipo
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList()
                    : itemsDonacion
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
        onChanged: (value) => setState(() => widget.value = value),
        validator: (value) =>
            value == null ? 'Seleccione ${widget.label.toLowerCase()}.' : null,
      ),
    );
  }
}
