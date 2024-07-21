import 'dart:convert';

import 'package:clinica_app/model/host.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class LoginDao {
  static String host = Host.getHost;

  Future<dynamic> login(String usuario, String password) async {
    var passInBytes = utf8.encode(password);
    var passHash = sha256.convert(passInBytes).toString();

    var response = await http.post(
      Uri.parse('$host/login_personal.php'),
      body: {
        'usuario': usuario,
        'password': passHash,
      },
    );
    return json.decode(response.body);
  }
}
