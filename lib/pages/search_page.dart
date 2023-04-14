import 'package:clinica_app/Widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  final Function currentIndex;

  const SearchPage({super.key, required this.currentIndex});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool buscar = false, buscarDni = false;
  GlobalKey<FormState> formKeyBuscar = GlobalKey<FormState>();
  TextEditingController buscarController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController sangreController = TextEditingController();
  TextEditingController donacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        buttonBuscar(),
        const SizedBox(height: 20),
        Card(
          elevation: 18,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputForm(
                    label: 'Nombres',
                    active: false,
                    inputController: nombresController),
                const SizedBox(height: 10),
                InputForm(
                    label: 'Apellidos',
                    active: false,
                    inputController: nombresController),
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
                buttonTriaje()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buttonBuscar() {
    return Form(
      key: formKeyBuscar,
      child: SizedBox(
        width: 210,
        child: TextFormField(
          controller: buscarController,
          keyboardType: TextInputType.number,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.white),
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
                  onPressed: () => setState(() => submitBuscar()),
                ),
              )),
          onTap: () => setState(() => buscarDni = true),
          validator: (value) => value!.isEmpty ? 'Ingrese DNI válido.' : null,
        ),
      ),
    );
  }

  Widget buttonTriaje() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: buscar ? 45 : 0,
        margin: const EdgeInsets.only(top: 10),
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
          onPressed: () => setState(() => widget.currentIndex(2)),
          child: const Text('Realizar Triaje',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void submitBuscar() {
    if (formKeyBuscar.currentState!.validate()) {
      if (buscarController.text == '74644014') {
        buscar = true;
        buscarDni = false;
        nombresController.text = 'Jesus Rafael';
        apellidosController.text = 'Piscoya Bances';
        fechaController.text = '03/05/2001';
        edadController.text = '21';
        sexoController.text = 'Masculino';
        estadoController.text = 'Soltero';
        sangreController.text = 'O+';
        donacionController.text = 'Sí';
        buscarController.clear();
        FocusScope.of(context).unfocus();
      } else {
        buscar = false;
        limpiar();
        Fluttertoast.showToast(
            msg: "Paciente no registrado.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void limpiar() {
    nombresController.clear();
    apellidosController.clear();
    fechaController.clear();
    edadController.clear();
    sexoController.clear();
    estadoController.clear();
    sangreController.clear();
    donacionController.clear();
  }
}
