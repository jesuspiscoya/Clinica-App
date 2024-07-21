class Personal {
  late String codigo;
  late String? tipoPersonal;
  late String? especialidad;
  late String? nombres;
  late String? apellidoPaterno;
  late String? apellidoMaterno;
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
  late String? correo;
  late String? usuario;
  late String? password;

  Personal({
    required this.codigo,
    this.tipoPersonal,
    this.especialidad,
    this.nombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.dni,
    this.telefono,
    this.fechaNacimiento,
    this.sexo,
    this.estadoCivil,
    this.departamento,
    this.provincia,
    this.distrito,
    this.direccion,
    this.estado,
    this.fechaRegistro,
    this.correo,
    this.usuario,
    this.password,
  });

  Personal.fromLogin(Map<String, dynamic> item)
      : codigo = item['cod_personal'],
        especialidad = item['nom_especialidad'],
        tipoPersonal = item['tipo_personal'],
        nombres = item['nombres'],
        apellidoPaterno = item['ape_paterno'],
        apellidoMaterno = item['ape_materno'],
        fechaNacimiento = item['fec_nacimiento'],
        correo = item['correo'],
        telefono = item['telefono'],
        direccion = item['direccion'];

  Map<String, Object?> toActualizar() {
    return {
      'cod_personal': codigo,
      'correo': correo,
      'telefono': telefono,
      'direccion': direccion,
    };
  }

  Map<String, Object?> toPassword() {
    return {
      'cod_personal': codigo,
      'password': password,
    };
  }
}
