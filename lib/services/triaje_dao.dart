import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/triaje.dart';
import 'package:http/http.dart' as http;

class TriajeDao {
  static const String host = '192.168.100.134';

  Future<bool> registrar(Triaje triaje) async {
    var response = await http.post(
        Uri.parse("http://$host/api_clinica/registrar_triaje.php"),
        body: triaje.toMap());
    return json.decode(response.body);
  }

  Future<List<Atencion>> listarPendientes() async {
    var response = await http
        .post(Uri.parse("http://$host/api_clinica/listar_triajes.php"));
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromTriaje(e))
        .toList();
  }

  // Future<dynamic> buscar(String dni) async {
  //   var response = await http.post(
  //       Uri.parse("http://$host/api_clinica/buscar_triaje.php"),
  //       body: {'dni': dni});
  //   return json.decode(response.body);
  // }
}
