import 'package:clinica_app/widgets/dropdown_form.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/widgets/dropdown_ubigeo.dart';
import 'package:clinica_app/model/paciente.dart';
import 'package:clinica_app/services/paciente_dao.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKeyRegistrar = GlobalKey<FormState>();
  TextEditingController dniController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  DropdownForm dropdownSexo = DropdownForm(label: 'Sexo');
  DropdownForm dropdownEstado = DropdownForm(label: 'Estado Civil');
  DropdownForm dropdownTipo = DropdownForm(label: 'Tip. Sangre');
  DropdownForm dropdownDonacion = DropdownForm(label: 'Don. Órganos');
  late DropdownUbigeo dropdownDistrito = DropdownUbigeo(label: 'Distrito');
  late DropdownUbigeo dropdownProvincia = DropdownUbigeo(label: 'Provincia');
  late DropdownUbigeo dropdownDepartamento = DropdownUbigeo(
    label: 'Departamento',
    selectItem: (departamento) => setState(
      () => dropdownProvincia = DropdownUbigeo(
        label: 'Provincia',
        departamento: departamento,
        selectItem: (provincia) => setState(
          () => dropdownDistrito = DropdownUbigeo(
              label: 'Distrito',
              departamento: departamento,
              provincia: provincia),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          'Registrar Nuevo Paciente',
          style: TextStyle(
              color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
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
                  InputForm(
                    label: 'DNI',
                    active: true,
                    inputController: dniController,
                    buscarDni: (nombres, apellidos) => setState(() {
                      nombresController.text = nombres;
                      apellidosController.text = apellidos;
                      FocusScope.of(context).unfocus();
                    }),
                  ),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Nombres',
                      active: false,
                      inputController: nombresController),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Apellidos',
                      active: false,
                      inputController: apellidosController),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Teléfono',
                      active: true,
                      inputController: telefonoController),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Fecha de Nacimiento',
                      active: true,
                      inputController: fechaController),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dropdownSexo,
                      const SizedBox(width: 10),
                      dropdownEstado
                    ],
                  ),
                  const SizedBox(height: 10),
                  dropdownDepartamento,
                  const SizedBox(height: 10),
                  dropdownProvincia,
                  const SizedBox(height: 10),
                  dropdownDistrito,
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Dirección',
                      active: true,
                      inputController: direccionController),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dropdownTipo,
                      const SizedBox(width: 10),
                      dropdownDonacion
                    ],
                  ),
                  const SizedBox(height: 13),
                  buttonRegistrar()
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15)
      ],
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
        onPressed: () => setState(() => submitRegistrar()),
        child: const Text('Registrar Paciente',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void submitRegistrar() {
    if (formKeyRegistrar.currentState!.validate()) {
      List<String> apellidos = apellidosController.text.split(' ');
      DateTime fechaInput =
          DateFormat('dd/MM/yyyy').parse(fechaController.text);
      String fechaOutput = DateFormat('yyyy/MM/dd').format(fechaInput);
      Paciente paciente = Paciente(
          nombres: nombresController.text,
          paterno: apellidos[0],
          materno: apellidos[1],
          dni: dniController.text,
          telefono: telefonoController.text,
          nacimiento: fechaOutput,
          sexo: dropdownSexo.value!,
          estadoCivil: dropdownEstado.value!,
          departamento: dropdownDepartamento.valueLabel!,
          provincia: dropdownProvincia.valueLabel!,
          distrito: dropdownDistrito.valueLabel!,
          direccion: direccionController.text,
          nhc: '10000',
          sangre: dropdownTipo.value!,
          donacion: dropdownDonacion.value!);
      PacienteDao().registrar(paciente).then((value) {
        if (value) {
          limpiar();
          showToast('Paciente registrado con éxito.', Colors.green);
        } else {
          showToast('Error al registrar paciente.', Colors.red);
          FocusScope.of(context).unfocus();
        }
      });
    }
  }

  void limpiar() {
    // dniController.clear();
    nombresController.clear();
    apellidosController.clear();
    telefonoController.clear();
    fechaController.clear();
    direccionController.clear();
    dropdownSexo = DropdownForm(label: 'Sexo');
    dropdownEstado = DropdownForm(label: 'Estado Civil');
    dropdownTipo = DropdownForm(label: 'Tip. Sangre');
    dropdownDonacion = DropdownForm(label: 'Don. Órganos');
    dropdownDistrito = DropdownUbigeo(label: 'Distrito');
    dropdownProvincia = DropdownUbigeo(label: 'Provincia');
    dropdownDepartamento = DropdownUbigeo(
        label: 'Departamento',
        selectItem: (departamento) => setState(() => dropdownProvincia =
            DropdownUbigeo(
                label: 'Provincia',
                departamento: departamento,
                selectItem: (provincia) => setState(() => dropdownDistrito =
                    DropdownUbigeo(
                        label: 'Distrito',
                        departamento: departamento,
                        provincia: provincia)))));
    FocusScope.of(context).unfocus();
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
