import 'package:clinica_app/model/especialidad.dart';
import 'package:clinica_app/services/atencion_dao.dart';
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
  List<Especialidad> itemsEspecialidad = <Especialidad>[];

  @override
  void initState() {
    super.initState();
    widget.label == 'Especialidad' ? getItems() : null;
  }

  void getItems() async {
    final data = await AtencionDao().listarEspecialidad();
    setState(() => itemsEspecialidad = data);
  }

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
        items: widget.label == 'Especialidad'
            ? itemsEspecialidad
                .map((e) => DropdownMenuItem<String>(
                    value: e.codigo, child: Text(e.nombre)))
                .toList()
            : widget.label == 'Sexo'
                ? itemsSexo
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList()
                : widget.label == 'Estado Civil'
                    ? itemsEstado
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList()
                    : widget.label == 'Tip. Sangre'
                        ? itemsTipo
                            .map((e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)))
                            .toList()
                        : itemsDonacion
                            .map((e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)))
                            .toList(),
        onChanged: (value) => setState(() => widget.value = value),
        validator: (value) =>
            value == null ? 'Seleccione ${widget.label.toLowerCase()}.' : null,
      ),
    );
  }
}
