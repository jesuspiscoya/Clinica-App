import 'package:animate_do/animate_do.dart';
import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/services/atencion_dao.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/widgets/listview_build.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PendientesPage extends StatefulWidget {
  final String codMedico;

  const PendientesPage({super.key, required this.codMedico});

  @override
  State<PendientesPage> createState() => _PendientesPageState();
}

class _PendientesPageState extends State<PendientesPage> {
  GlobalKey<FormState> formKeyRegistrar = GlobalKey<FormState>();
  TextEditingController buscarController = TextEditingController();
  TextEditingController sintomasController = TextEditingController();
  TextEditingController diagnosticoController = TextEditingController();
  TextEditingController tratamientoController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();
  TextEditingController examenesController = TextEditingController();
  bool selected = false;
  late Atencion atencion;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 15),
        const Text('Atenciones Pendientes',
            style: TextStyle(
                color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 15),
        !selected
            ? ListviewBuild(
                medico: true,
                listaFuture: AtencionDao().listarPendientes(),
                selectPendiente: (atencion) => setState(() {
                      selected = true;
                      this.atencion = atencion;
                    }))
            : SlideInRight(
                duration: const Duration(milliseconds: 250),
                from: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: TriajeDao().buscarTriaje(atencion.codTriaje!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.greenAccent[400]),
                      );
                    }

                    return Card(
                      elevation: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: formKeyRegistrar,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buttonRegresar(),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Paciente: ${atencion.nombres} ${atencion.paterno} ${atencion.materno}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'DNI:  ${atencion.dni}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Especialidad: ${atencion.codEspecialidad}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Signos Vitales',
                                style: TextStyle(
                                    color: Colors.greenAccent.shade400,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Table(
                                border: TableBorder.all(
                                    width: 3, color: Colors.blue),
                                children: [
                                  TableRow(children: [
                                    textLabel(true, 'Peso'),
                                    textLabel(true, 'Talla')
                                  ]),
                                  TableRow(children: [
                                    textLabel(false, snapshot.data!.peso),
                                    textLabel(false, snapshot.data!.talla)
                                  ]),
                                  TableRow(children: [
                                    textLabel(true, 'Temperatura'),
                                    textLabel(true, 'Presión')
                                  ]),
                                  TableRow(children: [
                                    textLabel(
                                        false, snapshot.data!.temperatura),
                                    textLabel(false, snapshot.data!.presion)
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 15),
                              InputForm(
                                  label: 'Síntomas',
                                  active: true,
                                  inputController: sintomasController),
                              const SizedBox(height: 8),
                              InputForm(
                                  label: 'Diagnóstico',
                                  active: true,
                                  inputController: diagnosticoController),
                              const SizedBox(height: 8),
                              InputForm(
                                  label: 'Tratamiento',
                                  active: true,
                                  inputController: tratamientoController),
                              const SizedBox(height: 8),
                              InputForm(
                                  label: 'Observaciones',
                                  active: true,
                                  inputController: observacionesController),
                              const SizedBox(height: 8),
                              InputForm(
                                  label: 'Exámenes',
                                  active: true,
                                  inputController: examenesController),
                              const SizedBox(height: 15),
                              buttonRegistrar()
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget buttonRegresar() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 1.7,
            colors: <Color>[
              Color.fromARGB(255, 108, 200, 236),
              Color.fromARGB(255, 35, 102, 189)
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => selected = false),
        child: const Text('Regresar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
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
              Color.fromARGB(255, 106, 221, 156),
              Color.fromARGB(255, 28, 162, 99),
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
          codigo: this.atencion.codigo,
          codMedico: widget.codMedico,
          sintomas: sintomasController.text,
          diagnostico: diagnosticoController.text,
          tratamiento: tratamientoController.text,
          observaciones: observacionesController.text,
          examenes: examenesController.text);
      AtencionDao().modificar(atencion).then((value) {
        if (value) {
          limpiar();
          setState(() => selected = false);
          showToast('Atención registrada con éxito.', Colors.green);
        } else {
          showToast('Error al registrar atención.', Colors.red);
          FocusScope.of(context).unfocus();
        }
      });
    }
  }

  Widget textLabel(bool titulo, String label) {
    return Container(
      color: titulo ? Colors.blue : null,
      child: Center(
        heightFactor: titulo ? 1.3 : 1.5,
        child: Text(
          label,
          style: TextStyle(
              color: titulo ? Colors.white : null,
              fontSize: titulo ? 16 : null,
              fontWeight: titulo ? FontWeight.w700 : null),
        ),
      ),
    );
  }

  void limpiar() {
    sintomasController.clear();
    diagnosticoController.clear();
    tratamientoController.clear();
    observacionesController.clear();
    examenesController.clear();
    selected = false;
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
