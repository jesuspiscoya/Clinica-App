import 'package:clinica_app/widgets/alertdialog_lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListviewBuild extends StatelessWidget {
  final bool medico;
  final Future<List<dynamic>> future;

  const ListviewBuild({
    super.key,
    required this.medico,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                FutureBuilder(
                  future: future,
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
                            itemBuilder: (context, index, animation) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: const Offset(0, 0),
                              ).animate(CurvedAnimation(
                                  parent: animation, curve: Curves.bounceOut)),
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
                                  child: listaCard(
                                      snapshot.data!.elementAt(index)),
                                ),
                                onTap: () => !medico
                                    ? showDialog(
                                        context: context,
                                        builder: (context) => AlertdialogLista(
                                            codigoEnfermera: snapshot.data!
                                                .elementAt(
                                                    index)['cod_enfermera'],
                                            codigoPaciente: snapshot.data!
                                                .elementAt(
                                                    index)['cod_paciente'],
                                            dni: snapshot.data!
                                                .elementAt(index)['dni'],
                                            nhc: snapshot.data!
                                                .elementAt(index)['nhc'],
                                            paciente:
                                                '${snapshot.data!.elementAt(index)['nombres']} ${snapshot.data!.elementAt(index)['ape_paterno']} ${snapshot.data!.elementAt(index)['ape_materno']}'),
                                      )
                                    : null,
                              ),
                            ),
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
          const SizedBox(height: 13)
        ],
      ),
    );
  }

  Widget listaCard(dynamic paciente) {
    List<String> nombres = paciente['nombres'].split(' ');
    DateTime fechaInput =
        DateFormat('yyyy-MM-dd hh:mm').parse(paciente['fec_registro']);

    return Row(
      children: [
        const SizedBox(width: 12, height: 56),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(paciente['dni'],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              Text('${nombres[0]} ${paciente['ape_paterno']}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(DateFormat('dd/MM/yyyy').format(fechaInput),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            Text(DateFormat('hh:mm a').format(fechaInput),
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
