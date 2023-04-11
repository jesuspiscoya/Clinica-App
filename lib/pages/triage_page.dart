import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TriagePAge extends StatefulWidget {
  const TriagePAge({super.key});

  @override
  State<TriagePAge> createState() => _TriagePAgeState();
}

class _TriagePAgeState extends State<TriagePAge> {
  bool triaje = false;
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
                          Flexible(
                            child: TextFormField(
                              controller: pesoController,
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.black12,
                                labelText: 'Peso',
                                labelStyle: TextStyle(height: 1.5),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Ingrese peso.' : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              controller: tallaController,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.black12,
                                  labelText: 'Talla',
                                  labelStyle: TextStyle(height: 1.5),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              validator: (value) =>
                                  value!.isEmpty ? 'Ingrese talla.' : null,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: temperaturaController,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.black12,
                                  labelText: 'Temperatura',
                                  labelStyle: TextStyle(height: 1.5),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              validator: (value) => value!.isEmpty
                                  ? 'Ingrese temperatura.'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextFormField(
                              controller: presionController,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.black12,
                                  labelText: 'Presión',
                                  labelStyle: TextStyle(height: 1.5),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              validator: (value) =>
                                  value!.isEmpty ? 'Ingrese presión.' : null,
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
                Container(
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
                    child: const Text('Registrar Triaje',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    onPressed: () => setState(() => submitTriaje()),
                  ),
                ),
                const SizedBox(height: 18)
              ],
            ))
      ],
    );
  }

  void submitTriaje() {
    if (formKeyTriaje.currentState!.validate()) {
      limpiar();
      triaje = false;
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
