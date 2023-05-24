import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginDao {
  static const String host = 'http://192.168.100.134/api_clinica';
  static const String url =
      'https://compucenterintegrador2.000webhostapp.com/api_clinica';

  Future<dynamic> loginEnfermera(String usuario, String password) async {
    var response = await http.post(
      Uri.parse('$url/login_enfermera.php'),
      body: {
        'usuario': usuario,
        'password': password,
      },
    );
    return json.decode(response.body);
  }

  Future<dynamic> loginMedico(String usuario, String password) async {
    var response = await http.post(
      Uri.parse('$url/login_medico.php'),
      body: {
        'usuario': usuario,
        'password': password,
      },
    );
    return json.decode(response.body);
  }
}
