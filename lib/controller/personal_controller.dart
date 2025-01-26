import 'dart:convert';

import 'package:clinica_app/model/host.dart';
import 'package:clinica_app/model/personal.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class PersonalController {
  static String host = Host.getHost;

  Future<dynamic> actualizarPersonal(Personal personal) async {
    var response = await http.post(Uri.parse('$host/actualizar_personal.php'),
        body: personal.toActualizar());
    return json.decode(response.body);
  }

  Future<bool> actualizarPassword(Personal personal) async {
    var passInBytes = utf8.encode(personal.password!);
    var passHash = sha256.convert(passInBytes).toString();
    personal.password = passHash;

    var response = await http.post(Uri.parse('$host/actualizar_password.php'),
        body: personal.toPassword());
    return json.decode(response.body);
  }
}
