import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownUbigeo extends StatefulWidget {
  final String label;
  String? value;
  final Function? selectItem;
  String? departamento;
  String? provincia;

  DropdownUbigeo({
    super.key,
    required this.label,
    this.selectItem,
    this.departamento,
    this.provincia,
  });

  @override
  State<DropdownUbigeo> createState() => _DropdownUbigeoState();
}

class _DropdownUbigeoState extends State<DropdownUbigeo> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FutureBuilder(
        future: widget.label == 'Departamento'
            ? getDepartamento()
            : widget.label == 'Provincia'
                ? getProvincia(widget.departamento)
                : getDistrito(widget.departamento, widget.provincia),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var data = snapshot.data!;
          return DropdownButtonFormField<String>(
            value: widget.value,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.black12,
                labelText: widget.label,
                labelStyle: const TextStyle(height: 1.7, fontSize: 15),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            items: data
                .map((e) => DropdownMenuItem<String>(
                    value: widget.label == 'Departamento'
                        ? e['departamento']
                        : widget.label == 'Provincia'
                            ? e['provincia']
                            : e['distrito'],
                    child: Text('${e['nombre']}')))
                .toList(),
            onChanged: (value) => setState(() {
              widget.value = value;
              widget.label != 'Distrito' ? widget.selectItem!(value) : null;
            }),
            validator: (value) => value == null
                ? 'Seleccione ${widget.label.toLowerCase()}.'
                : null,
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getDepartamento() async {
    String urlApi =
        "https://cdn.jsdelivr.net/npm/ubigeo-peru@2.0.2/src/ubigeo-reniec.json";

    http.Response response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
      List jsonData = json.decode(response.body) as List;
      for (var element in jsonData) {
        if (element['provincia'] == '00') {
          items.add(element);
        }
      }
      return items;
    } else {
      throw response.statusCode;
    }
  }

  Future<List<Map<String, dynamic>>> getProvincia(String? departamento) async {
    String urlApi =
        "https://cdn.jsdelivr.net/npm/ubigeo-peru@2.0.2/src/ubigeo-reniec.json";

    http.Response response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
      List jsonData = json.decode(response.body) as List;
      for (var element in jsonData) {
        if (element['departamento'] == departamento &&
            element['provincia'] != '00' &&
            element['distrito'] == '00') {
          items.add(element);
        }
      }
      return items;
    } else {
      throw response.statusCode;
    }
  }

  Future<List<Map<String, dynamic>>> getDistrito(
      String? departamento, String? provincia) async {
    String urlApi =
        "https://cdn.jsdelivr.net/npm/ubigeo-peru@2.0.2/src/ubigeo-reniec.json";

    http.Response response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> items = [];
      List jsonData = json.decode(response.body) as List;
      for (var element in jsonData) {
        if (element['departamento'] == departamento &&
            element['provincia'] == provincia &&
            element['distrito'] != '00') {
          items.add(element);
        }
      }
      return items;
    } else {
      throw response.statusCode;
    }
  }
}
