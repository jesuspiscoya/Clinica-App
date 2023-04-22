import 'dart:convert';

import 'package:clinica_app/model/paciente.dart';
import 'package:http/http.dart' as http;

class PacienteDao {
  Future<dynamic> registrar(Paciente paciente) async {
    var response = await http.post(
        Uri.parse("http://192.168.100.134/app_clinica/registrar_paciente.php"),
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
}
