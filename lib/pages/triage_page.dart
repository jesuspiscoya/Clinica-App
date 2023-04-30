import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/model/triaje.dart';
import 'package:clinica_app/services/paciente_dao.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TriagePage extends StatefulWidget {
  final String dni, nhc, paciente;

  const TriagePage({
    super.key,
    required this.dni,
    required this.nhc,
    required this.paciente,
  });

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
  void initState() {
    super.initState();
    if (widget.dni.isNotEmpty) {
      dniController.text = widget.dni;
      nhcController.text = widget.nhc;
      pacienteController.text = widget.paciente;
    }
  }

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
        Card(
          elevation: 15,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: formKeyTriaje,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    inputDni(),
                    const SizedBox(height: 8),
                    InputForm(
                        label: 'NHC',
                        active: false,
                        inputController: nhcController),
                    const SizedBox(height: 8),
                    InputForm(
                        label: 'Paciente',
                        active: false,
                        inputController: pacienteController),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InputForm(
                            label: 'Peso',
                            active: true,
                            inputController: pesoController),
                        const SizedBox(width: 8),
                        InputForm(
                            label: 'Talla',
                            active: true,
                            inputController: tallaController)
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InputForm(
                            label: 'Temperatura',
                            active: true,
                            inputController: temperaturaController),
                        const SizedBox(width: 8),
                        InputForm(
                            label: 'Presión',
                            active: true,
                            inputController: presionController)
                      ],
                    ),
                  ]),
                ),
              ),
              buttonTriaje(),
              const SizedBox(height: 18)
            ],
          ),
        ),
      ],
    );
  }

  Widget inputDni() {
    return TextFormField(
      key: keyDni,
      controller: dniController,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.black12,
          labelText: 'DNI',
          labelStyle: const TextStyle(height: 1.5, fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          suffixIcon: !load
              ? IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    getPaciente(dniController.text);
                  },
                  icon: const Icon(Icons.search_rounded, size: 30))
              : Container(
                  width: 0,
                  height: 0,
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator()),
          border: const UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onFieldSubmitted: (value) => getPaciente(dniController.text),
      validator: (value) => value!.isEmpty ? 'Ingrese DNI.' : null,
    );
  }

  Future<void> getPaciente(String dni) async {
    if (keyDni.currentState!.validate()) {
      if (dniController.text.length > 7) {
        setState(() => load = true);
        PacienteDao().buscar(dni).then((value) {
          if (value == null) {
            load = false;
            Fluttertoast.showToast(
                msg: "Paciente no registrado.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            load = false;
            setState(() {
              nhcController.text = value['nhc'];
              pacienteController.text =
                  '${value['nombres']} ${value['ape_paterno']} ${value['ape_materno']}';
            });
          }
        });
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

  Widget buttonTriaje() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3,
            colors: <Color>[
              Color.fromARGB(255, 106, 221, 156),
              Color.fromARGB(255, 28, 162, 99),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitTriaje()),
        child: const Text('Registrar Triaje',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void submitTriaje() {
    if (formKeyTriaje.currentState!.validate()) {
      Triaje triaje = Triaje(
          dni: dniController.text,
          peso: pesoController.text,
          talla: tallaController.text,
          temperatura: temperaturaController.text,
          presion: presionController.text);
      TriajeDao().registrar(triaje).then((value) {
        if (value) {
          limpiar();
          Fluttertoast.showToast(
              msg: "Datos registrados con éxito.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          FocusScope.of(context).unfocus();
        } else {
          Fluttertoast.showToast(
              msg: "Error al registrar datos.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          FocusScope.of(context).unfocus();
        }
      });
    }
  }

  void limpiar() {
    dniController.clear();
    nhcController.clear();
    pacienteController.clear();
    pesoController.clear();
    tallaController.clear();
    temperaturaController.clear();
    presionController.clear();
  }
}
