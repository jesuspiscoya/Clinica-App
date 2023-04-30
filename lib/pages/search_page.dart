import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/services/paciente_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final Function currentIndex;

  const SearchPage({super.key, required this.currentIndex});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool buscar = false, buscarDni = false;
  GlobalKey<FormState> formKeyBuscar = GlobalKey<FormState>();
  TextEditingController dniController = TextEditingController();
  TextEditingController nhcController = TextEditingController();
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
        const Text(
          'Buscar Paciente',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputForm(
                    label: 'NHC',
                    active: false,
                    inputController: nhcController),
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
          onPressed: () => setState(() => widget.currentIndex(
              2,
              dniController.text,
              nhcController.text,
              '${nombresController.text} ${apellidosController.text}')),
          child: const Text('Realizar Triaje',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
              Fluttertoast.showToast(
                  msg: "Paciente no registrado.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              buscar = true;
              buscarDni = false;
              nhcController.text = value['nhc'];
              nombresController.text = value['nombres'];
              apellidosController.text =
                  '${value['ape_paterno']} ${value['ape_materno']}';
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

  void limpiar() {
    nhcController.clear();
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
