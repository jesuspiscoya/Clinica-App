import 'package:animate_do/animate_do.dart';
import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/services/atencion_dao.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:clinica_app/widgets/listview_build.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistorialPage extends StatefulWidget {
  final String codMedico;

  const HistorialPage({super.key, required this.codMedico});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
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
      children: [
        const SizedBox(height: 15),
        const Text('Historial de Atenciones',
            style: TextStyle(
                color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 15),
        !selected
            ? ListviewBuild(
                medico: true,
                listaFuture: AtencionDao().listarHistorial(widget.codMedico),
                selectPendiente: (atencion) => setState(() {
                      selected = true;
                      this.atencion = atencion;
                      sintomasController.text = this.atencion.sintomas!;
                      diagnosticoController.text = this.atencion.diagnostico!;
                      tratamientoController.text = this.atencion.tratamiento!;
                      observacionesController.text =
                          this.atencion.observaciones!;
                      examenesController.text = this.atencion.examenes!;
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buttonRegresar(),
                            const SizedBox(height: 15),
                            Text(
                                'Fecha: ${DateFormat('dd/MM/yyyy').format(atencion.fecha)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 15),
                            Table(
                              border:
                                  TableBorder.all(width: 3, color: Colors.blue),
                              children: [
                                TableRow(
                                    children: [textLabel(true, 'Paciente')]),
                                TableRow(children: [
                                  textLabel(false,
                                      '${atencion.nombres} ${atencion.paterno} ${atencion.materno}')
                                ]),
                                TableRow(children: [textLabel(true, 'DNI')]),
                                TableRow(
                                    children: [textLabel(false, atencion.dni)])
                              ],
                            ),
                            Table(
                              border:
                                  TableBorder.all(width: 3, color: Colors.blue),
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
                                  textLabel(false, snapshot.data!.temperatura),
                                  textLabel(false, snapshot.data!.presion)
                                ]),
                              ],
                            ),
                            const SizedBox(height: 15),
                            InputForm(
                                label: 'Síntomas',
                                active: false,
                                inputController: sintomasController),
                            const SizedBox(height: 8),
                            InputForm(
                                label: 'Diagnóstico',
                                active: false,
                                inputController: diagnosticoController),
                            const SizedBox(height: 8),
                            InputForm(
                                label: 'Tratamiento',
                                active: false,
                                inputController: tratamientoController),
                            const SizedBox(height: 8),
                            InputForm(
                                label: 'Observaciones',
                                active: false,
                                inputController: observacionesController),
                            const SizedBox(height: 8),
                            InputForm(
                                label: 'Exámenes',
                                active: false,
                                inputController: examenesController),
                          ],
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
}
