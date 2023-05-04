import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/services/atencion_dao.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/services/paciente_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AtencionPage extends StatefulWidget {
  final String codEnfermera;
  final Function currentIndex;

  const AtencionPage({
    super.key,
    required this.codEnfermera,
    required this.currentIndex,
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
  bool buscar = false, buscarDni = false;
  String? especialidad;
  late String codPaciente;
  List<dynamic> itemsEspecialidad = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  void getItems() async {
    final data = await AtencionDao().listarEspecialidad();
    setState(() {
      itemsEspecialidad = data;
    });
  }

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
                  dropdownEspecialidad(),
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
          onTap: () => setState(() => buscarDni = true),
          onFieldSubmitted: (value) => submitBuscar(),
          validator: (value) => value!.isEmpty ? 'Ingrese DNI válido.' : null,
        ),
      ),
    );
  }

  void submitBuscar() {
    if (formKeyBuscar.currentState!.validate()) {
      if (dniController.text.length > 7) {
        PacienteDao().buscar(dniController.text).then((value) {
          setState(() {
            if (value == null) {
              buscar = false;
              limpiar();
              showToast('Paciente no registrado.', Colors.red);
            } else {
              buscar = true;
              buscarDni = false;
              codPaciente = value['cod_paciente'];
              nhcController.text = value['nhc'];
              pacienteController.text =
                  '${value['nombres']} ${value['ape_paterno']} ${value['ape_materno']}';
              DateTime fechaInput =
                  DateFormat('dd-MM-yyyy').parse(value['fec_nacimiento']);
              fechaController.text =
                  DateFormat('dd/MM/yyyy').format(fechaInput);
              edadController.text = '${DateTime.now().year - fechaInput.year}';
              sexoController.text = value['sexo'];
              estadoController.text = value['est_civil'];
              sangreController.text = value['tip_sangre'];
              donacionController.text = value['don_organos'];
              FocusScope.of(context).unfocus();
            }
          });
        });
      } else {
        showToast('Ingrese DNI válido.', Colors.red);
      }
    }
  }

  Widget dropdownEspecialidad() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.black12,
          labelText: 'Especialidad',
          labelStyle: TextStyle(height: 1.7, fontSize: 15),
          border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      items: itemsEspecialidad
          .map((e) => DropdownMenuItem<String>(
              value: e['cod_especialidad'],
              child: Text('${e['nom_especialidad']}')))
          .toList(),
      onChanged: (value) => setState(() => especialidad = value!),
      validator: (value) => value == null ? 'Seleccione especialidad.' : null,
    );
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
        onPressed: () => submitRegistrar(),
        child: const Text('Registrar Atención',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void submitRegistrar() {
    if (formKeyRegistrar.currentState!.validate()) {
      Atencion atencion = Atencion(
          codPaciente: codPaciente,
          codEspecialidad: especialidad!,
          codEnfermera: widget.codEnfermera);
      AtencionDao().registrar(atencion).then((value) {
        if (value) {
          limpiar();
          showToast('Atención registrada con éxito.', Colors.green);
          FocusScope.of(context).unfocus();
        } else {
          showToast('Atención registrada con éxito.', Colors.red);
          FocusScope.of(context).unfocus();
        }
      });
    }
  }

  // Widget buttonTriaje() {
  //   return AnimatedSize(
  //     duration: const Duration(milliseconds: 300),
  //     child: Container(
  //       height: buscar ? 45 : 0,
  //       margin: const EdgeInsets.only(top: 10),
  //       decoration: const BoxDecoration(
  //           gradient: RadialGradient(
  //             center: Alignment.bottomLeft,
  //             radius: 3,
  //             colors: <Color>[
  //               Color.fromARGB(255, 108, 200, 236),
  //               Color.fromARGB(255, 35, 102, 189),
  //             ],
  //           ),
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       child: MaterialButton(
  //         shape: const StadiumBorder(),
  //         onPressed: () => submitRegistrar(),
  //         child: const Text('Registrar Atención',
  //             style:
  //                 TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
  //       ),
  //     ),
  //   );
  // }

  void limpiar() {
    dniController.clear();
    especialidad = null;
    nhcController.clear();
    pacienteController.clear();
    fechaController.clear();
    edadController.clear();
    sexoController.clear();
    estadoController.clear();
    sangreController.clear();
    donacionController.clear();
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
