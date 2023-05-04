import 'package:intl/intl.dart';

class Atencion {
  final String codPaciente;
  late final String codEspecialidad;
  late final String codEnfermera;
  late final DateTime fecha;
  late final String nhc;
  late final String dni;
  late final String nombres;
  late final String paterno;
  late final String materno;

  Atencion({
    required this.codPaciente,
    required this.codEspecialidad,
    required this.codEnfermera,
  });

  Atencion.fromTriaje(Map<String, dynamic> item)
      : codPaciente = item['cod_paciente'],
        codEnfermera = item['cod_enfermera'],
        nhc = item['nhc'],
        dni = item['dni'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        fecha = DateFormat('yyyy-MM-dd hh:mm').parse(item['fec_registro']);

  Atencion.fromPendiente(Map<String, dynamic> item)
      : codPaciente = item['cod_paciente'],
        dni = item['dni'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        fecha = DateFormat('yyyy-MM-dd hh:mm').parse(item['fec_registro']);

  Map<String, Object?> toMap() {
    return {
      'cod_paciente': codPaciente,
      'cod_especialidad': codEspecialidad,
      'cod_enfermera': codEnfermera,
    };
  }
}
