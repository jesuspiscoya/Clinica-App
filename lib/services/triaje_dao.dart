import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:clinica_app/model/triaje.dart';
import 'package:http/http.dart' as http;

class TriajeDao {
  static const String host = 'http://10.0.2.2:80/api_clinica';

  Future<Triaje> buscarTriaje(String codTriaje) async {
    var response = await http.post(Uri.parse('$host/buscar_triaje.php'),
        body: {'cod_triaje': codTriaje});
    return Triaje.fromMap(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<bool> registrar(Triaje triaje) async {
    var response = await http.post(Uri.parse('$host/registrar_triaje.php'),
        body: triaje.toMap());
    return json.decode(response.body);
  }

  Future<List<Atencion>> listarPendientes() async {
    var response = await http.post(Uri.parse('$host/listar_triajes.php'));
    return (json.decode(response.body) as List)
        .map((e) => Atencion.fromTriaje(e))
        .toList();
  }

  Future<bool> verificarTriaje(String codPaciente) async {
    var response = await http.post(Uri.parse('$host/verificar_triaje.php'),
        body: {'cod_paciente': codPaciente});
    return json.decode(response.body);
  }
}
