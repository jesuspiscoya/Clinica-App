import 'package:clinica_app/Widgets/dropdonw_form.dart';
import 'package:clinica_app/Widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool buscar = false, buscarDni = false;
  GlobalKey<FormState> formKeyRegistrar = GlobalKey<FormState>();
  TextEditingController buscarController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  DropdownForm dropdownSexo = DropdownForm(label: 'Sexo');
  DropdownForm dropdownEstado = DropdownForm(label: 'Estado Civil');
  DropdownForm dropdownTipo = DropdownForm(label: 'Tip. Sangre');
  DropdownForm dropdownDonacion = DropdownForm(label: 'Don. Órganos');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      label: 'Nombres',
                      active: true,
                      inputController: nombresController),
                  const SizedBox(height: 10),
                  InputForm(
                      label: 'Apellidos',
                      active: true,
                      inputController: apellidosController),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputForm(
                          label: 'Nacimiento',
                          active: true,
                          inputController: fechaController),
                      const SizedBox(width: 10),
                      InputForm(
                          label: 'Edad',
                          active: true,
                          inputController: edadController),
                    ],
                  ),
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
        )
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
      limpiar();
      Fluttertoast.showToast(
          msg: "Datos registrados con éxito.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 16.0);
      FocusScope.of(context).unfocus();
    }
  }

  void limpiar() {
    nombresController.clear();
    apellidosController.clear();
    fechaController.clear();
    edadController.clear();
    dropdownSexo = DropdownForm(label: 'Sexo');
    dropdownEstado = DropdownForm(label: 'Estado Civil');
    dropdownTipo = DropdownForm(label: 'Tip. Sangre');
    dropdownDonacion = DropdownForm(label: 'Don. Órganos');
  }
}
