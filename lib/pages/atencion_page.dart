import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/paciente.dart';
import 'package:clinica_app/services/atencion_dao.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/dropdown_form.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/services/paciente_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AtencionPage extends StatefulWidget {
  final String codEnfermera;

  const AtencionPage({
    super.key,
    required this.codEnfermera,
  });

  @override
  State<AtencionPage> createState() => _AtencionPageState();
}

class _AtencionPageState extends State<AtencionPage> {
  GlobalKey<FormState> formKeyRegistrar = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyBuscar = GlobalKey<FormState>();
  TextEditingController dniController = TextEditingController();
  TextEditingController nhcController = TextEditingController();
  TextEditingController pacienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController sangreController = TextEditingController();
  TextEditingController donacionController = TextEditingController();
  DropdownForm dropdownEspecialidad = DropdownForm(label: 'Especialidad');
  late String codPaciente;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Registrar Nueva Atención',
          style: TextStyle(
              color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 15),
        inputBuscar(),
        const SizedBox(height: 20),
        Card(
          elevation: 18,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: formKeyRegistrar,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dropdownEspecialidad,
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'NHC',
                      active: false,
                      inputController: nhcController),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Paciente',
                      active: false,
                      inputController: pacienteController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InputForm(
                          label: 'Fech. Nacimiento',
                          active: false,
                          inputController: fechaController),
                      const SizedBox(width: 10),
                      InputForm(
                          label: 'Edad',
                          active: false,
                          inputController: edadController)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InputForm(
                          label: 'Sexo',
                          active: false,
                          inputController: sexoController),
                      const SizedBox(width: 10),
                      InputForm(
                          label: 'Estado Civil',
                          active: false,
                          inputController: estadoController)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InputForm(
                          label: 'Tipo de Sangre',
                          active: false,
                          inputController: sangreController),
                      const SizedBox(width: 10),
                      InputForm(
                          label: 'Don. Órganos',
                          active: false,
                          inputController: donacionController)
                    ],
                  ),
                  const SizedBox(height: 15),
                  buttonRegistrar()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget inputBuscar() {
    return Form(
      key: formKeyBuscar,
      child: SizedBox(
        width: 210,
        child: TextFormField(
          controller: dniController,
          keyboardType: TextInputType.number,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          inputFormatters: [
            LengthLimitingTextInputFormatter(8),
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: const EdgeInsets.only(left: 15),
              fillColor: const Color(0xFF131935),
              hintText: 'Ingrese DNI',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)),
              errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1.3, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(30)),
              suffixIcon: Container(
                height: 0,
                width: 0,
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: 1.1,
                    colors: <Color>[
                      Color(0xFF4284DB),
                      Color(0xFF29EAC4),
                    ],
                  ),
                ),
                child: MaterialButton(
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.search_rounded,
                      size: 23, color: Colors.white),
                  onPressed: () => submitBuscar(),
                ),
              )),
          onFieldSubmitted: (value) => setState(() => submitBuscar()),
          validator: (value) => value!.isEmpty ? 'Ingrese DNI válido.' : null,
        ),
      ),
    );
  }

  void submitBuscar() {
    if (formKeyBuscar.currentState!.validate()) {
      if (dniController.text.length > 7) {
        PacienteDao().buscar(dniController.text).then((value) {
          if (value == null) {
            limpiar();
            showToast('Paciente no registrado.', Colors.red);
          } else {
            value as Paciente;
            codPaciente = value.codigo!;
            nhcController.text = value.nhc;
            pacienteController.text =
                '${value.nombres} ${value.paterno} ${value.materno}';
            DateTime fechaInput =
                DateFormat('dd-MM-yyyy').parse(value.nacimiento);
            fechaController.text = DateFormat('dd/MM/yyyy').format(fechaInput);
            edadController.text = '${DateTime.now().year - fechaInput.year}';
            sexoController.text = value.sexo;
            estadoController.text = value.estadoCivil;
            sangreController.text = value.sangre;
            donacionController.text = value.donacion;
            FocusScope.of(context).unfocus();
          }
        });
      } else {
        showToast('Ingrese DNI válido.', Colors.red);
      }
    }
  }

  Widget buttonRegistrar() {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3,
            colors: <Color>[
              Color.fromARGB(255, 108, 200, 236),
              Color.fromARGB(255, 35, 102, 189),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitRegistrar()),
        child: const Text('Registrar Atención',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void submitRegistrar() {
    if (formKeyRegistrar.currentState!.validate()) {
      TriajeDao().verificarTriaje(codPaciente).then((value) {
        if (value) {
          Atencion atencion = Atencion(
              codPaciente: codPaciente,
              codEspecialidad: dropdownEspecialidad.value!,
              codEnfermera: widget.codEnfermera);
          AtencionDao().registrar(atencion).then((value) {
            if (value) {
              limpiar();
              showToast('Atención registrada con éxito.', Colors.green);
            } else {
              showToast('Error al registrar atención.', Colors.red);
              FocusScope.of(context).unfocus();
            }
          });
        } else {
          showToast(
              'Paciente pendiente a triaje.', Colors.amberAccent.shade700);
        }
      });
    }
  }

  void limpiar() {
    setState(() {
      dniController.clear();
      dropdownEspecialidad = DropdownForm(label: 'Especialidad');
      nhcController.clear();
      pacienteController.clear();
      fechaController.clear();
      edadController.clear();
      sexoController.clear();
      estadoController.clear();
      sangreController.clear();
      donacionController.clear();
      FocusScope.of(context).unfocus();
    });
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
