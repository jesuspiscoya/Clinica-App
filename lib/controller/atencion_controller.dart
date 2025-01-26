import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/especialidad.dart';
import 'package:clinica_app/model/host.dart';
import 'package:http/http.dart' as http;

class AtencionController {
  static String host = Host.getHost;

  Future<bool> registrar(Atencion atencion) async {
    var response = await http.post(Uri.parse('$host/registrar_atencion.php'),
        body: atencion.toRegistrar());
    print(atencion.codPaciente);
    print(atencion.codEspecialidad);
    print(atencion.codEnfermera);
    print(response.body);
    return json.decode(response.body);
  }

  Future<bool> modificar(Atencion atencion) async {
    var response = await http.post(Uri.parse('$host/modificar_atencion.php'),
        body: atencion.toModificar());
    return json.decode(response.body);
  }

  Future<List<Especialidad>> listarEspecialidad() async {
    var response = await http.get(Uri.parse('$host/listar_especialidad.php'));
    return (json.decode(response.body) as List)
        .map((e) => Especialidad.fromMap(e))
        .toList();
  }

  Future<List<Atencion>> listarPendientes(String codMedico) async {
    var response = await http.post(Uri.parse('$host/listar_pendientes.php'),
        body: {'cod_medico': codMedico});
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromPendiente(e))
        .toList();
  }

  Future<List<Atencion>> listarHistorial(String codMedico) async {
    var response = await http.post(Uri.parse('$host/listar_historial.php'),
        body: {'cod_medico': codMedico});
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromHistorial(e))
        .toList();
  }
}
