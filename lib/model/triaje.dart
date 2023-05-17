class Triaje {
  late final String? codigo;
  late final String codEnfermera;
  late final String codPaciente;
  final String peso;
  final String talla;
  final String temperatura;
  final String presion;

  Triaje({
    this.codigo,
    required this.codEnfermera,
    required this.codPaciente,
    required this.peso,
    required this.talla,
    required this.temperatura,
    required this.presion,
  });

  Triaje.fromMap(Map<String, dynamic> item)
      : peso = item['peso'],
        talla = item['talla'],
        temperatura = item['temperatura'],
        presion = item['presion'];

  Map<String, Object?> toMap() {
    return {
      'cod_atencion': codigo,
      'cod_enfermera': codEnfermera,
      'cod_paciente': codPaciente,
      'peso': peso,
      'talla': talla,
      'temperatura': temperatura,
      'presion': presion,
    };
  }
}
