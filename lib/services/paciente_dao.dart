import 'dart:convert';

import 'package:clinica_app/model/paciente.dart';
import 'package:http/http.dart' as http;

class PacienteDao {
  static const String host = '192.168.100.134';

  Future<dynamic> registrar(Paciente paciente) async {
    var response = await http.post(
        Uri.parse("http://$host/api_clinica/registrar_paciente.php"),
        body: {
          'nombre': paciente.nombres,
          'paterno': paciente.apellidoPaterno,
          'materno': paciente.apellidoMaterno,
          'dni': paciente.dni,
          'telefono': paciente.telefono,
          'nacimiento': paciente.fechaNacimiento,
          'sexo': paciente.sexo,
          'civil': paciente.estadoCivil,
          'departamento': paciente.departamento,
          'provincia': paciente.provincia,
          'distrito': paciente.distrito,
          'direccion': paciente.direccion,
          'nhc': paciente.nhc.toString(),
          'sangre': paciente.tipoSangre,
          'organos': paciente.donacionOrganos,
        });
    return json.decode(response.body);
  }

  Future<dynamic> buscar(String dni) async {
    var response = await http.post(
        Uri.parse("http://$host/api_clinica/buscar_paciente.php"),
        body: {'dni': dni});
    return json.decode(response.body);
  }
}
