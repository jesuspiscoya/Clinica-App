import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/triaje.dart';
import 'package:http/http.dart' as http;

class TriajeDao {
  static const String host = 'http://192.168.100.134/api_clinica';
  static const String url =
      'https://compucenterintegrador2.000webhostapp.com/api_clinica';

  Future<Triaje> buscarTriaje(String codTriaje) async {
    var response = await http.post(Uri.parse('$url/buscar_triaje.php'),
        body: {'cod_triaje': codTriaje});
    return Triaje.fromMap(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<bool> registrar(Triaje triaje) async {
    var response = await http.post(Uri.parse('$url/registrar_triaje.php'),
        body: triaje.toMap());
    return json.decode(response.body);
  }

  Future<List<Atencion>> listarPendientes() async {
    var response = await http.post(Uri.parse('$url/listar_triajes.php'));
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromTriaje(e))
        .toList();
  }

  Future<bool> verificarTriaje(String codPaciente) async {
    var response = await http.post(Uri.parse('$url/verificar_triaje.php'),
        body: {'cod_paciente': codPaciente});
    return json.decode(response.body);
  }
}
