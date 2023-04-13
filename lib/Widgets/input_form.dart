import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputForm extends StatefulWidget {
  final String label;
  final bool active;
  final TextEditingController inputController;

  const InputForm({
    super.key,
    required this.label,
    required this.active,
    required this.inputController,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        autofocus: false,
        readOnly: !widget.active,
        enabled: widget.active,
        controller: widget.inputController,
        keyboardType: identical(widget.label, 'Edad')
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: identical(widget.label, 'Edad')
            ? [LengthLimitingTextInputFormatter(3)]
            : [],
        decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.black12,
            labelText: widget.label,
            labelStyle: const TextStyle(height: 1.7, fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            suffixIcon: identical(widget.label, 'Nacimiento')
                ? IconButton(
                    onPressed: () => fechaNacimiento(),
                    icon: const Icon(Icons.date_range_rounded, size: 23))
                : null,
            border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        validator: (value) =>
            value!.isEmpty ? 'Ingrese ${widget.label.toLowerCase()}.' : null,
      ),
    );
  }

  void fechaNacimiento() async {
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
      setState(() => widget.inputController.text = newDate.toString());
    }
  }
}
