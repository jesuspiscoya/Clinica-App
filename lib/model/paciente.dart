class Paciente {
  late String? codigo;
  late String nombres;
  late String paterno;
  late String materno;
  late String dni;
  late String telefono;
  late String nacimiento;
  late String sexo;
  late String estadoCivil;
  late String departamento;
  late String provincia;
  late String distrito;
  late String direccion;
  late String nhc;
  late String sangre;
  late String donacion;

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
