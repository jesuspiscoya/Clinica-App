class Enfermera {
  final String codigo;
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

  Enfermera({
    required this.codigo,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
  });

  Enfermera.fromLogin(Map<String, dynamic> item)
      : codigo = item['cod_enfermera'],
        nombres = item['nombres'],
        apellidoPaterno = item['ape_paterno'],
        apellidoMaterno = item['ape_materno'];

  // Map<String, Object?> toLogin() {
  //   return {
  //     'usuario': user,
  //     'password': pass,
  //   };
  // }
}
