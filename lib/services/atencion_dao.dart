import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/especialidad.dart';
import 'package:http/http.dart' as http;

class AtencionDao {
  static const String host = 'http://192.168.100.134/api_clinica';
  static const String url =
      'https://compucenterintegrador2.000webhostapp.com/api_clinica';

  Future<bool> registrar(Atencion atencion) async {
    var response = await http.post(Uri.parse('$url/registrar_atencion.php'),
        body: atencion.toRegistrar());
    return json.decode(response.body);
  }

  Future<bool> modificar(Atencion atencion) async {
    var response = await http.post(Uri.parse('$url/modificar_atencion.php'),
        body: atencion.toModificar());
    return json.decode(response.body);
  }

  Future<List<Especialidad>> listarEspecialidad() async {
    var response = await http.post(Uri.parse('$url/listar_especialidad.php'));
    return (json.decode(response.body) as List)
        .map((e) => Especialidad.fromMap(e))
        .toList();
  }

  Future<List<Atencion>> listarPendientes() async {
    var response = await http.post(Uri.parse('$url/listar_pendientes.php'));
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromPendiente(e))
        .toList();
  }

  Future<List<Atencion>> listarHistorial(String codMedico) async {
    var response = await http.post(Uri.parse('$url/listar_historial.php'),
        body: {'cod_medico': codMedico});
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromHistorial(e))
        .toList();
  }
}
