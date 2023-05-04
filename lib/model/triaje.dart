class Triaje {
  final String codEnfermera;
  final String codPaciente;
  final String peso;
  final String talla;
  final String temperatura;
  final String presion;

  Triaje({
    required this.codEnfermera,
    required this.codPaciente,
    required this.peso,
    required this.talla,
    required this.temperatura,
    required this.presion,
  });

  // Triaje.fromLogin(Map<String, dynamic> item)
  //     : codigo = int.parse(item['cod_enfermera']),
  //       nombres = item['nombres'],
  //       apellidoPaterno = item['ape_paterno'],
  //       apellidoMaterno = item['ape_materno'];

  Map<String, Object?> toMap() {
    return {
      'cod_enfermera': codEnfermera,
      'cod_paciente': codPaciente,
      'peso': peso,
      'talla': talla,
      'temperatura': temperatura,
      'presion': presion,
    };
  }
}
