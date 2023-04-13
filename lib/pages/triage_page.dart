import 'package:clinica_app/Widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TriagePAge extends StatefulWidget {
  const TriagePAge({super.key});

  @override
  State<TriagePAge> createState() => _TriagePAgeState();
}

class _TriagePAgeState extends State<TriagePAge> {
  GlobalKey<FormState> formKeyTriaje = GlobalKey<FormState>();
  TextEditingController pesoController = TextEditingController();
  TextEditingController tallaController = TextEditingController();
  TextEditingController temperaturaController = TextEditingController();
  TextEditingController presionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  child: Column(children: [
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
    pesoController.clear();
    tallaController.clear();
    temperaturaController.clear();
    presionController.clear();
  }
}
