import 'dart:convert';

import 'package:clinica_app/model/atencion.dart';
import 'package:http/http.dart' as http;

class AtencionDao {
  static const String host = '192.168.100.134';

  Future<dynamic> registrar(Atencion atencion) async {
    var response = await http.post(
        Uri.parse("http://$host/api_clinica/registrar_atencion.php"),
        body: {
          'cod_paciente': atencion.codPaciente,
          'cod_especialidad': atencion.codEspecialidad,
          'cod_enfermera': atencion.codEnfermera,
        });
    return json.decode(response.body);
  }

  Future<List<dynamic>> listarEspecialidad() async {
    var response = await http
        .post(Uri.parse("http://$host/api_clinica/listar_especialidad.php"));
    return json.decode(response.body);
  }

  Future<List<dynamic>> listarPendientes() async {
    var response = await http
        .post(Uri.parse("http://$host/api_clinica/listar_pendientes.php"));
    return json.decode(response.body);
  }
}
