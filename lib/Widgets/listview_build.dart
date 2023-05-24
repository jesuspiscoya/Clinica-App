import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/services/triaje_dao.dart';
import 'package:clinica_app/widgets/alertdialog_lista.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ListviewBuild extends StatefulWidget {
  final bool medico;
  final Future<List<Atencion>> listaFuture;
  final Function? selectPendiente;

  const ListviewBuild({
    super.key,
    required this.medico,
    required this.listaFuture,
    this.selectPendiente,
  });

  @override
  State<ListviewBuild> createState() => _ListviewBuildState();
}

class _ListviewBuildState extends State<ListviewBuild> {
  List<Atencion> listaAtencion = <Atencion>[], lista = <Atencion>[];

  @override
  void initState() {
    getPendientes();
    super.initState();
  }

  void getPendientes() async {
    final data = await widget.listaFuture;
    setState(() {
      listaAtencion = data;
      lista = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            inputBuscar(),
            const SizedBox(height: 10),
            lista.isEmpty
                ? const CircularProgressIndicator()
                : listaAtencion.isEmpty
                    ? Center(
                        child: Text('Sin información para mostrar.',
                            style: TextStyle(
                                color: Colors.greenAccent.shade400,
                                fontWeight: FontWeight.w700)))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: listaAtencion.length,
                        itemBuilder: (context, index) {
                          Atencion atencion = listaAtencion.elementAt(index);
                          return GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
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
                                          codAtencion: atencion.codigo!,
                                          codEnfermera: atencion.codEnfermera!,
                                          codPaciente: atencion.codPaciente!,
                                          dni: atencion.dni,
                                          nhc: atencion.nhc,
                                          paciente:
                                              '${atencion.nombres} ${atencion.paterno} ${atencion.materno}',
                                          selectPendiente: () => TriajeDao()
                                              .listarPendientes()
                                              .then((value) => setState(() =>
                                                  listaAtencion = value))))
                                  : setState(
                                      () => widget.selectPendiente!(atencion)));
                        },
                      ),
          ],
        ),
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

  Widget inputBuscar() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.black12,
          labelText: 'Buscar por DNI',
          labelStyle: TextStyle(height: 1.5, fontSize: 15),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          prefixIcon: Icon(Icons.search_rounded, size: 30),
          border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onChanged: (value) => buscarPaciente(value),
    );
  }

  void buscarPaciente(String input) {
    setState(() => listaAtencion = lista
        .where((element) => element.dni.contains(input.toLowerCase()))
        .toList());
  }
}
