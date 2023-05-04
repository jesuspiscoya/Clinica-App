class Atencion {
  final int? codigo;
  final String codPaciente;
  final String codEspecialidad;
  final String codEnfermera;
  final bool? estado;
  final DateTime? fecha;

  Atencion({
    this.codigo,
    required this.codPaciente,
    required this.codEspecialidad,
    required this.codEnfermera,
    this.estado,
    this.fecha,
  });

  // Triaje.fromLogin(Map<String, dynamic> item)
  //     : codigo = int.parse(item['cod_enfermera']),
  //       nombres = item['nombres'],
  //       apellidoPaterno = item['ape_paterno'],
  //       apellidoMaterno = item['ape_materno'];

  // Map<String, Object?> toMap() {
  //   return {
  //     'cod_art': codigo,
  //     'nombre': nombre,
  //   };
  // }
}
