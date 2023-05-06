import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  GlobalKey<FormFieldState> keyDni = GlobalKey<FormFieldState>();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        key: widget.label == 'DNI' ? keyDni : null,
        enabled: widget.active,
        controller: widget.inputController,
        maxLines: widget.label == 'Motivo' ||
                widget.label == 'Síntomas' ||
                widget.label == 'Diagnóstico' ||
                widget.label == 'Tratamiento' ||
                widget.label == 'Observaciones' ||
                widget.label == 'Exámenes'
            ? 3
            : 1,
        textInputAction: widget.label == 'Motivo' ||
                widget.label == 'Síntomas' ||
                widget.label == 'Diagnóstico' ||
                widget.label == 'Tratamiento' ||
                widget.label == 'Observaciones' ||
                widget.label == 'Exámenes'
            ? TextInputAction.none
            : widget.label == 'DNI'
                ? TextInputAction.search
                : widget.label == 'Presión'
                    ? TextInputAction.send
                    : TextInputAction.next,
        keyboardType: widget.label == 'DNI' ||
                widget.label == 'Teléfono' ||
                widget.label == 'Peso' ||
                widget.label == 'Talla' ||
                widget.label == 'Temperatura'
            ? TextInputType.number
            : widget.label == 'Motivo' ||
                    widget.label == 'Síntomas' ||
                    widget.label == 'Diagnóstico' ||
                    widget.label == 'Tratamiento' ||
                    widget.label == 'Observaciones' ||
                    widget.label == 'Exámenes'
                ? TextInputType.multiline
                : widget.label == 'Fecha de Nacimiento' ||
                        widget.label == 'Presión'
                    ? TextInputType.datetime
                    : TextInputType.text,
        inputFormatters: widget.label == 'DNI'
            ? [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.digitsOnly
              ]
            : widget.label == 'Teléfono'
                ? [
                    LengthLimitingTextInputFormatter(9),
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
                : widget.label == 'Fecha de Nacimiento'
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
    if (keyDni.currentState!.validate()) {
      if (widget.inputController.text.length > 7) {
        setState(() => load = true);
        String urlApi = "https://api.apis.net.pe/v1/dni?numero=$dni";
        http.Response response = await http.get(Uri.parse(urlApi));

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonData = json.decode(response.body);
          setState(() => widget.buscarDni!(jsonData['nombres'],
              '${jsonData['apellidoPaterno']} ${jsonData['apellidoMaterno']}'));
        } else {
          setState(() => widget.buscarDni!('', ''));
        }
        load = false;
      } else {
        Fluttertoast.showToast(
            msg: "Ingrese DNI válido.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
