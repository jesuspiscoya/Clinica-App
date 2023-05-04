import 'package:animate_do/animate_do.dart';
import 'package:clinica_app/model/triaje.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertdialogLista extends StatefulWidget {
  final String codigoEnfermera, codigoPaciente, dni, nhc, paciente;

  const AlertdialogLista({
    super.key,
    required this.codigoEnfermera,
    required this.codigoPaciente,
    required this.dni,
    required this.nhc,
    required this.paciente,
  });

  @override
  State<AlertdialogLista> createState() => _AlertdialogListaState();
}

class _AlertdialogListaState extends State<AlertdialogLista> {
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
    return ZoomIn(
      duration: const Duration(milliseconds: 200),
      child: AlertDialog(
        backgroundColor: const Color(0xFF151C4F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Center(child: textLabel('Nuevo Triaje', 19, Colors.cyan)),
        titlePadding: const EdgeInsets.symmetric(vertical: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Form(
                        key: formKeyTriaje,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    buttonTriaje(),
                    const SizedBox(height: 15)
                  ],
                ),
              ),
              const SizedBox(height: 18)
            ],
          ),
        ),
      ),
    );
  }

  Widget inputDni() {
    return TextFormField(
      enabled: false,
      controller: dniController,
      decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.black12,
          labelText: 'DNI',
          labelStyle: TextStyle(height: 1.5, fontSize: 15),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      validator: (value) => value!.isEmpty ? 'Ingrese DNI.' : null,
    );
  }

  Widget buttonTriaje() {
    return Container(
      height: 45,
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
          codPaciente: widget.codigoPaciente,
          codEnfermera: widget.codigoEnfermera,
          peso: pesoController.text,
          talla: tallaController.text,
          temperatura: temperaturaController.text,
          presion: presionController.text);
      TriajeDao().registrar(triaje).then((value) {
        if (value) {
          limpiar();
          showToast('Datos registrados con éxito.', Colors.green);
          Navigator.of(context).pop();
        } else {
          showToast('Error al registrar datos.', Colors.red);
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

  Widget textLabel(String texto, double? size, Color color) {
    return Text(
      texto,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color),
    );
  }

  void showToast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
