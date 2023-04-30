import 'dart:convert';

import 'package:clinica_app/model/triaje.dart';
import 'package:http/http.dart' as http;

class TriajeDao {
  static const String host = '192.168.100.134';
  Future<dynamic> registrar(Triaje triaje) async {
    var response = await http.post(
        Uri.parse("http://$host/api_clinica/registrar_triaje.php"),
        body: {
          'dni': triaje.dni,
          'peso': triaje.peso,
          'talla': triaje.talla,
          'temperatura': triaje.temperatura,
          'presion': triaje.presion,
        });
    return json.decode(response.body);
  }

  // Future<dynamic> buscar(String dni) async {
  //   var response = await http.post(
  //       Uri.parse("http://$host/api_clinica/buscar_triaje.php"),
  //       body: {'dni': dni});
  //   return json.decode(response.body);
  // }
}
