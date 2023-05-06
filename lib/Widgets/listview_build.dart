import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/widgets/alertdialog_lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListviewBuild extends StatefulWidget {
  final bool medico;
  final Future<List<Atencion>> future;
  final Function? selectPendiente;

  const ListviewBuild({
    super.key,
    required this.medico,
    required this.future,
    this.selectPendiente,
  });

  @override
  State<ListviewBuild> createState() => _ListviewBuildState();
}

class _ListviewBuildState extends State<ListviewBuild> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                  future: widget.future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.greenAccent[400]),
                      );
                    }

                    return snapshot.data!.isNotEmpty
                        ? AnimatedList(
                            key: UniqueKey(),
                            shrinkWrap: true,
                            initialItemCount: snapshot.data!.length,
                            itemBuilder: (context, index, animation) {
                              Atencion atencion =
                                  snapshot.data!.elementAt(index);
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: const Offset(0, 0),
                                ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.bounceOut)),
                                child: GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment(0, 5),
                                        colors: <Color>[
                                          Color(0xFF4284DB),
                                          Color(0xFF29EAC4),
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: listaCard(atencion),
                                  ),
                                  onTap: () => !widget.medico
                                      ? showDialog(
                                          context: context,
                                          builder: (context) => AlertdialogLista(
                                              codigoEnfermera:
                                                  atencion.codEnfermera,
                                              codigoPaciente:
                                                  atencion.codPaciente,
                                              dni: atencion.dni,
                                              nhc: atencion.nhc,
                                              paciente:
                                                  '${atencion.nombres} ${atencion.paterno} ${atencion.materno}'),
                                        )
                                      : setState(() {
                                          widget.selectPendiente!(
                                              true,
                                              '${atencion.nombres} ${atencion.paterno} ${atencion.materno}',
                                              atencion.dni,
                                              atencion.codPaciente);
                                        }),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text('Sin pacientes pendientes.',
                                style: TextStyle(
                                    color: Colors.greenAccent.shade400,
                                    fontWeight: FontWeight.w700)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget listaCard(Atencion atencion) {
    List<String> nombres = atencion.nombres.split(' ');

    return Row(
      children: [
        const SizedBox(width: 12, height: 56),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(atencion.dni,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              Text('${nombres[0]} ${atencion.paterno}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(DateFormat('dd/MM/yyyy').format(atencion.fecha),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            Text(DateFormat('hh:mm a').format(atencion.fecha),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600))
          ],
        ),
        const SizedBox(width: 10, height: 56)
      ],
    );
  }
}
