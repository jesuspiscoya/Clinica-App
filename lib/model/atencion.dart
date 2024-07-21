import 'package:intl/intl.dart';

class Atencion {
  late String? codigo;
  late String? codPaciente;
  late String? codEspecialidad;
  late String? codEnfermera;
  late String? codTriaje;
  late String? codMedico;
  late String? sintomas;
  late String? diagnostico;
  late String? tratamiento;
  late String? observaciones;
  late String? examenes;
  late DateTime fecha;
  late String nhc;
  late String dni;
  late String nombres;
  late String paterno;
  late String materno;

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
