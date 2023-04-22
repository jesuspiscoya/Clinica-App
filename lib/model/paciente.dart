class Paciente {
  final int? codigo;
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String dni;
  final String telefono;
  final String fechaNacimiento;
  final String sexo;
  final String estadoCivil;
  final String departamento;
  final String provincia;
  final String distrito;
  final String direccion;
  final int nhc;
  final String tipoSangre;
  final String donacionOrganos;

  Paciente({
    this.codigo,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.dni,
    required this.telefono,
    required this.fechaNacimiento,
    required this.sexo,
    required this.estadoCivil,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.direccion,
    required this.nhc,
    required this.tipoSangre,
    required this.donacionOrganos,
  });

  Paciente.fromLogin(Map<String, dynamic> item)
      : codigo = int.parse(item['cod_paciente']),
        nombres = item['nombres'],
        apellidoPaterno = item['ape_paterno'],
        apellidoMaterno = item['ape_materno'],
        dni = item['dni'],
        telefono = item['telefono'],
        fechaNacimiento = item['fec_nacimiento'],
        sexo = item['sexo'],
        estadoCivil = item['est_civil'],
        departamento = item['departamento'],
        provincia = item['provincia'],
        distrito = item['distrito'],
        direccion = item['direccion'],
        nhc = int.parse(item['nhc']),
        tipoSangre = item['tip_sangre'],
        donacionOrganos = item['don_organos'];

  // Map<String, Object?> toMap() {
  //   return {
  //     'cod_art': codigo,
  //     'nombre': nombre,
  //   };
  // }
}
