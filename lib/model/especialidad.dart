class Especialidad {
  String codigo;
  String nombre;

  Especialidad.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_especialidad']!,
        nombre = item['nom_especialidad']!;
}
