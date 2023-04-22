import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginDao {
  Future<dynamic> loginEnfermera(String usuario, String password) async {
    var response = await http.post(
        Uri.parse("http://192.168.100.134/app_clinica/login_enfermera.php"),
        body: {
          'usuario': usuario,
          'password': password,
        });
    return json.decode(response.body);
  }
}
