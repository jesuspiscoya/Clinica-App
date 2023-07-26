import 'package:intl/intl.dart';

class Atencion {
  late final String? codigo;
  late final String? codPaciente;
  late final String? codEspecialidad;
  late final String? codEnfermera;
  late final String? codTriaje;
  late final String? codMedico;
  late final String? sintomas;
  late final String? diagnostico;
  late final String? tratamiento;
  late final String? observaciones;
  late final String? examenes;
  late final DateTime fecha;
  late final String nhc;
  late final String dni;
  late final String nombres;
  late final String paterno;
  late final String materno;

  Atencion({
    this.codigo,
    this.codPaciente,
    this.codEspecialidad,
    this.codEnfermera,
    this.codMedico,
    this.sintomas,
    this.diagnostico,
    this.tratamiento,
    this.observaciones,
    this.examenes,
  });

  Atencion.fromTriaje(Map<String, dynamic> item)
      : codigo = item['cod_atencion'],
        codPaciente = item['cod_paciente'],
        codEnfermera = item['cod_enfermera'],
        nhc = item['nhc'],
        dni = item['dni'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        fecha = DateFormat('yyyy-MM-dd HH:mm').parse(item['fec_registro']);

  Atencion.fromPendiente(Map<String, dynamic> item)
      : codigo = item['cod_atencion'],
        codPaciente = item['cod_paciente'],
        codEspecialidad = item['nom_especialidad'],
        codTriaje = item['cod_triaje'],
        dni = item['dni'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        fecha = DateFormat('yyyy-MM-dd HH:mm').parse(item['fec_registro']);

  Atencion.fromHistorial(Map<String, dynamic> item)
      : codigo = item['cod_atencion'],
        codPaciente = item['cod_paciente'],
        codTriaje = item['cod_triaje'],
        dni = item['dni'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        fecha = DateFormat('yyyy-MM-dd HH:mm').parse(item['fec_modificacion']),
        sintomas = item['sintomas'],
        diagnostico = item['diagnostico'],
        tratamiento = item['tratamiento'],
        observaciones = item['observaciones'],
        examenes = item['examenes'];

  Map<String, Object?> toRegistrar() {
    return {
      'cod_paciente': codPaciente,
      'cod_especialidad': codEspecialidad,
      'cod_enfermera': codEnfermera,
    };
  }

  Map<String, Object?> toModificar() {
    return {
      'cod_atencion': codigo,
      'cod_medico': codMedico,
      'sintomas': sintomas,
      'diagnostico': diagnostico,
      'tratamiento': tratamiento,
      'observaciones': observaciones,
      'examenes': examenes,
    };
  }
}
