import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/especialidad.dart';
import 'package:http/http.dart' as http;

class AtencionDao {
  static const String host = '192.168.100.134';

  Future<bool> registrar(Atencion atencion) async {
    var response = await http.post(
        Uri.parse('http://$host/api_clinica/registrar_atencion.php'),
        body: atencion.toRegistrar());
    return json.decode(response.body);
  }

  Future<bool> modificar(Atencion atencion) async {
    print(atencion.toModificar());
    var response = await http.post(
        Uri.parse('http://$host/api_clinica/modificar_atencion.php'),
        body: atencion.toModificar());
    print(response.body);
    return json.decode(response.body);
  }

  Future<List<Especialidad>> listarEspecialidad() async {
    var response = await http
        .post(Uri.parse('http://$host/api_clinica/listar_especialidad.php'));
    return (json.decode(response.body) as List)
        .map((e) => Especialidad.fromMap(e))
        .toList();
  }

  Future<List<Atencion>> listarPendientes() async {
    var response = await http
        .post(Uri.parse('http://$host/api_clinica/listar_pendientes.php'));
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromPendiente(e))
        .toList();
  }
}
