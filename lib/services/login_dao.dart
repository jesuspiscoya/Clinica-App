import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginDao {
  static const String host = 'http://10.0.2.2:80/api_clinica';

  Future<dynamic> loginEnfermera(String usuario, String password) async {
    var response = await http.post(
      Uri.parse('$host/login_enfermera.php'),
      body: {
        'usuario': usuario,
        'password': password,
      },
    );
    return json.decode(response.body);
  }

  Future<dynamic> loginMedico(String usuario, String password) async {
    var response = await http.post(
      Uri.parse('$host/login_medico.php'),
      body: {
        'usuario': usuario,
        'password': password,
      },
    );
    return json.decode(response.body);
  }
}
