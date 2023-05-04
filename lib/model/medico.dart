class Medico {
  final int codigo;
  final String especialidad;
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  late String? dni;
  late String? telefono;
  late String? fechaNacimiento;
  late String? sexo;
  late String? estadoCivil;
  late String? departamento;
  late String? provincia;
  late String? distrito;
  late String? direccion;
  late bool? estado;
  late String? fechaRegistro;
  late int? numColegiatura;
  late String? correoPersonal;
  late String? correoInstitucional;
  late String? usuario;
  late String? password;

  Medico({
    required this.codigo,
    required this.especialidad,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
  });

  Medico.fromLogin(Map<String, dynamic> item)
      : codigo = int.parse(item['cod_medico']),
        especialidad = item['nom_especialidad'],
        nombres = item['nombres'],
        apellidoPaterno = item['ape_paterno'],
        apellidoMaterno = item['ape_materno'];

  // Map<String, Object?> toMap() {
  //   return {
  //     'cod_art': codigo,
  //     'nombre': nombre,
  //   };
  // }
}
