class Triaje {
  final String dni;
  final String peso;
  final String talla;
  final String temperatura;
  final String presion;

  Triaje({
    required this.dni,
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

  // Map<String, Object?> toMap() {
  //   return {
  //     'cod_art': codigo,
  //     'nombre': nombre,
  //   };
  // }
}
