import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class InputForm extends StatefulWidget {
  final String label;
  final bool active;
  final TextEditingController inputController;
  final Function? buscarDni;

  const InputForm({
    super.key,
    required this.label,
    required this.active,
    required this.inputController,
    this.buscarDni,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        autofocus: false,
        readOnly: !widget.active,
        enabled: widget.active,
        controller: widget.inputController,
        textInputAction: widget.label == 'DNI'
            ? TextInputAction.search
            : widget.label == 'Presión'
                ? TextInputAction.send
                : TextInputAction.next,
        keyboardType:
            widget.label == 'DNI' ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.label == 'DNI'
            ? [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.digitsOnly
              ]
            : null,
        decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.black12,
            labelText: widget.label,
            labelStyle: const TextStyle(height: 1.5, fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            suffixIcon: widget.label == 'DNI'
                ? !load
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            getDatosDni(widget.inputController.text),
                        icon: const Icon(Icons.search_rounded, size: 30))
                    : Container(
                        width: 0,
                        height: 0,
                        padding: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator())
                : widget.label == 'Nacimiento'
                    ? IconButton(
                        onPressed: () => fechaNacimiento(),
                        icon: const Icon(Icons.date_range_rounded, size: 23))
                    : null,
            border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        onFieldSubmitted: (value) => widget.label == 'DNI'
            ? getDatosDni(widget.inputController.text)
            : null,
        validator: (value) =>
            value!.isEmpty ? 'Ingrese ${widget.label.toLowerCase()}.' : null,
      ),
    );
  }

  Future<void> getDatosDni(String dni) async {
    setState(() => load = true);
    String urlApi = "https://api.apis.net.pe/v1/dni?numero=$dni";
    http.Response response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      load = false;
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() => widget.buscarDni!(jsonData['nombres'],
          '${jsonData['apellidoPaterno']} ${jsonData['apellidoMaterno']}'));
    } else {
      load = false;
      setState(() => widget.buscarDni!('', ''));
    }
  }

  Future<void> fechaNacimiento() async {
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    final DateTime? newDate = await showDatePicker(
      context: context,
      locale: const Locale('es'),
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(year, month, day),
      helpText: 'Fecha de Nacimiento',
    );

    if (newDate != null) {
      setState(() => widget.inputController.text =
          DateFormat('dd/MM/yyyy').format(newDate));
    }
  }
}
