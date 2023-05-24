import 'dart:convert';

import 'package:clinica_app/model/paciente.dart';
import 'package:http/http.dart' as http;

class PacienteDao {
  static const String host = 'http://192.168.100.134/api_clinica';
  static const String url =
      'https://compucenterintegrador2.000webhostapp.com/api_clinica';

  Future<bool> registrar(Paciente paciente) async {
    var response = await http.post(Uri.parse('$url/registrar_paciente.php'),
        body: paciente.toMap());
    return json.decode(response.body);
  }

  Future<dynamic> buscar(String dni) async {
    var response = await http
        .post(Uri.parse('$url/buscar_paciente.php'), body: {'dni': dni});
    return json.decode(response.body) != null
        ? Paciente.fromMap(json.decode(response.body) as Map<String, dynamic>)
        : json.decode(response.body);
  }
}
