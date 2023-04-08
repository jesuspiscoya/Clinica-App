import 'package:animate_do/animate_do.dart';
import 'package:clinica_app/pages/navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String formattedDate =
      DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now());
  bool buscar = true, buscarDni = false, triaje = false;
  GlobalKey<FormState> formKeyBuscar = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyTriaje = GlobalKey<FormState>();
  TextEditingController buscarController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController sangreController = TextEditingController();
  TextEditingController donacionController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController tallaController = TextEditingController();
  TextEditingController temperaturaController = TextEditingController();
  TextEditingController presionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es-PE', '').then((value) =>
        formattedDate = DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavbarPage(),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            child: const Text('Clínica Piscoya')),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.blueAccent.shade400,
            fontSize: 18,
            fontWeight: FontWeight.w800),
        backgroundColor: const Color(0xFF131935),
        leading: Builder(
            builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: MaterialButton(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.sort_rounded,
                        color: Colors.white, size: 33),
                    onPressed: () => Scaffold.of(context).openDrawer()))),
        leadingWidth: 55,
        actions: [
          MaterialButton(
              minWidth: 0,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              child: const Icon(Icons.account_circle_rounded,
                  color: Colors.white, size: 45),
              onPressed: () => true),
          const SizedBox(width: 13)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Color(0xFF131935)),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Buenos Días, Jesus Piscoya',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.white,
                          height: 1.3,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 13),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          buscar
                              ? FadeInRight(
                                  from: 175,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                      height: 45,
                                      decoration: const BoxDecoration(
                                          gradient: RadialGradient(
                                            center: Alignment.bottomLeft,
                                            radius: 3.5,
                                            colors: <Color>[
                                              Color(0xFF4284DB),
                                              Color(0xFF29EAC4),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)))))
                              : const SizedBox(),
                          GestureDetector(
                            child: Container(
                                height: 45,
                                decoration: const BoxDecoration(),
                                child: Center(
                                    child: Text('Buscar',
                                        style: TextStyle(
                                            color: buscar
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)))),
                            onTap: () => setState(() => buscar = true),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          !buscar
                              ? FadeInLeft(
                                  from: 175,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                      height: 45,
                                      decoration: const BoxDecoration(
                                          gradient: RadialGradient(
                                            center: Alignment.bottomLeft,
                                            radius: 3.5,
                                            colors: <Color>[
                                              Color(0xFF4284DB),
                                              Color(0xFF29EAC4),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)))))
                              : const SizedBox(),
                          GestureDetector(
                            child: Container(
                                height: 45,
                                decoration: const BoxDecoration(),
                                child: Center(
                                    child: Text('Triaje',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: !buscar
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w700)))),
                            onTap: () => setState(() => buscar = false),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buscar
                ? BounceInRight(
                    duration: const Duration(milliseconds: 700),
                    child: Card(
                        elevation: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Form(
                              key: formKeyBuscar,
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: SizedBox(
                                  width: buscarDni ? 240 : 151,
                                  child: TextFormField(
                                    controller: buscarController,
                                    keyboardType: TextInputType.number,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(color: Colors.white),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        fillColor: const Color(0xFF131935),
                                        hintText: 'Ingrese DNI',
                                        hintStyle: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1.3,
                                                color: Colors.redAccent),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        suffixIcon: Container(
                                          height: 0,
                                          width: 0,
                                          margin: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              center: Alignment.bottomLeft,
                                              radius: 1.1,
                                              colors: <Color>[
                                                Color(0xFF4284DB),
                                                Color(0xFF29EAC4),
                                              ],
                                            ),
                                          ),
                                          child: MaterialButton(
                                            minWidth: 0,
                                            padding: EdgeInsets.zero,
                                            shape: const CircleBorder(),
                                            child: const Icon(
                                                Icons.search_rounded,
                                                size: 23),
                                            onPressed: () =>
                                                setState(() => submitBuscar()),
                                          ),
                                        )),
                                    onTap: () =>
                                        setState(() => buscarDni = true),
                                    validator: (value) =>
                                        value!.isEmpty ? 'DNI inválido.' : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(children: [
                                TextField(
                                  readOnly: true,
                                  enabled: false,
                                  controller: nombresController,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      labelText: 'Nombres',
                                      labelStyle: TextStyle(height: 1.5),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  readOnly: true,
                                  enabled: false,
                                  controller: apellidosController,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.black12,
                                      labelText: 'Apellidos',
                                      labelStyle: TextStyle(height: 1.5),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: fechaController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Fech. Nacimiento',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: edadController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Edad',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: sexoController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Sexo',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: estadoController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Estado Civil',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: sangreController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Tipo de Sangre',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        enabled: false,
                                        controller: donacionController,
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Don. Órganos',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                height: triaje ? 45 : 0,
                                margin: const EdgeInsets.only(top: 13),
                                decoration: const BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.bottomLeft,
                                      radius: 3,
                                      colors: <Color>[
                                        Color.fromARGB(255, 108, 200, 236),
                                        Color.fromARGB(255, 35, 102, 189),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: MaterialButton(
                                  child: const Text('Realizar Triaje',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () =>
                                      setState(() => buscar = false),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15)
                          ],
                        )),
                  )
                : BounceInLeft(
                    duration: const Duration(milliseconds: 700),
                    child: Card(
                        elevation: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            const SizedBox(height: 17),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Form(
                                key: formKeyTriaje,
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          controller: pesoController,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            labelText: 'Peso',
                                            labelStyle: TextStyle(height: 1.5),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          validator: (value) => value!.isEmpty
                                              ? 'Ingrese peso.'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: TextFormField(
                                          controller: tallaController,
                                          decoration: const InputDecoration(
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.black12,
                                              labelText: 'Talla',
                                              labelStyle:
                                                  TextStyle(height: 1.5),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)))),
                                          validator: (value) => value!.isEmpty
                                              ? 'Ingrese talla.'
                                              : null,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          controller: temperaturaController,
                                          decoration: const InputDecoration(
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.black12,
                                              labelText: 'Temperatura',
                                              labelStyle:
                                                  TextStyle(height: 1.5),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)))),
                                          validator: (value) => value!.isEmpty
                                              ? 'Ingrese temperatura.'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: TextFormField(
                                          controller: presionController,
                                          decoration: const InputDecoration(
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.black12,
                                              labelText: 'Presión',
                                              labelStyle:
                                                  TextStyle(height: 1.5),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)))),
                                          validator: (value) => value!.isEmpty
                                              ? 'Ingrese presión.'
                                              : null,
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(top: 15),
                              decoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.bottomLeft,
                                    radius: 3,
                                    colors: <Color>[
                                      Color.fromARGB(255, 106, 221, 156),
                                      Color.fromARGB(255, 28, 162, 99),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: MaterialButton(
                                child: const Text('Registrar Triaje',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () => setState(() => submitTriaje()),
                              ),
                            ),
                            const SizedBox(height: 18)
                          ],
                        )),
                  ),
          ],
        ),
      ),
    );
  }

  void submitBuscar() {
    if (formKeyBuscar.currentState!.validate()) {
      if (buscarController.text == '74644014') {
        triaje = true;
        buscarDni = false;
        nombresController.text = 'Jesus Rafael';
        apellidosController.text = 'Piscoya Bances';
        fechaController.text = '03/05/2001';
        edadController.text = '21';
        sexoController.text = 'Masculino';
        estadoController.text = 'Soltero';
        sangreController.text = 'O+';
        donacionController.text = 'Sí';
        buscarController.clear();
        FocusScope.of(context).unfocus();
      } else {
        limpiar();
        triaje = false;
        Fluttertoast.showToast(
            msg: "Paciente no registrado.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void submitTriaje() {
    if (formKeyTriaje.currentState!.validate()) {
      limpiar();
      triaje = false;
      Fluttertoast.showToast(
          msg: "Datos registrado con éxito.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.black,
          fontSize: 16.0);
      FocusScope.of(context).unfocus();
    }
  }

  void limpiar() {
    nombresController.clear();
    apellidosController.clear();
    fechaController.clear();
    edadController.clear();
    sexoController.clear();
    estadoController.clear();
    sangreController.clear();
    pesoController.clear();
    tallaController.clear();
    temperaturaController.clear();
    presionController.clear();
  }
}
