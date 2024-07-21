class Especialidad {
  late String codigo;
  late String nombre;

  Especialidad.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_especialidad']!,
        nombre = item['nom_especialidad']!;
}
