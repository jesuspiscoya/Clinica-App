import 'dart:convert';

import 'package:clinica_app/model/paciente.dart';
import 'package:http/http.dart' as http;

class PacienteDao {
  static const String host = 'http://10.0.2.2:80/api_clinica';

  Future<bool> registrar(Paciente paciente) async {
    var response = await http.post(Uri.parse('$host/registrar_paciente.php'),
        body: paciente.toMap());
    return json.decode(response.body);
  }

  Future<dynamic> buscar(String dni) async {
    var response = await http
        .post(Uri.parse('$host/buscar_paciente.php'), body: {'dni': dni});
    return json.decode(response.body) != null
        ? Paciente.fromMap(json.decode(response.body) as Map<String, dynamic>)
        : json.decode(response.body);
  }
}
