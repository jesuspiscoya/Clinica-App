class Paciente {
  final String? codigo;
  final String nombres;
  final String paterno;
  final String materno;
  late final String dni;
  late final String telefono;
  final String nacimiento;
  final String sexo;
  final String estadoCivil;
  late final String departamento;
  late final String provincia;
  late final String distrito;
  late final String direccion;
  final String nhc;
  final String sangre;
  final String donacion;

  Paciente({
    this.codigo,
    required this.nombres,
    required this.paterno,
    required this.materno,
    required this.dni,
    required this.telefono,
    required this.nacimiento,
    required this.sexo,
    required this.estadoCivil,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.direccion,
    required this.nhc,
    required this.sangre,
    required this.donacion,
  });

  Paciente.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_paciente'],
        nhc = item['nhc'],
        nombres = item['nombres'],
        paterno = item['ape_paterno'],
        materno = item['ape_materno'],
        nacimiento = item['fec_nacimiento'],
        sexo = item['sexo'],
        estadoCivil = item['est_civil'],
        sangre = item['tip_sangre'],
        donacion = item['don_organos'];

  Map<String, Object?> toMap() {
    return {
      'nombre': nombres,
      'paterno': paterno,
      'materno': materno,
      'dni': dni,
      'telefono': telefono,
      'nacimiento': nacimiento,
      'sexo': sexo,
      'civil': estadoCivil,
      'departamento': departamento,
      'provincia': provincia,
      'distrito': distrito,
      'direccion': direccion,
      'nhc': nhc,
      'sangre': sangre,
      'organos': donacion,
    };
  }
}
