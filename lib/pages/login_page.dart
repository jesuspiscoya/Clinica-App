import 'package:clinica_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Widget svgIcon = SvgPicture.asset('assets/image.svg',
      colorFilter: const ColorFilter.mode(Colors.greenAccent, BlendMode.srcIn));
  final Widget svgIcon2 = SvgPicture.asset('assets/image.svg',
      colorFilter: const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF131935),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 290,
              child: Stack(
                children: [
                  Container(
                    transform: Matrix4.translationValues(120, -50, 0),
                    child: svgIcon,
                  ),
                  Container(
                    transform: Matrix4.translationValues(-120, -70, 0),
                    child: svgIcon2,
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.only(top: 25),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(child: Image.asset('assets/logo.png')),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              transform: Matrix4.translationValues(0, -30, 0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Bienvenido',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent.shade700),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      cursorHeight: 22,
                      controller: usuarioController,
                      style: TextStyle(
                          color: Colors.greenAccent.shade700, fontSize: 17),
                      decoration: InputDecoration(
                        isDense: true,
                        label: const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('Usuario')),
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent.shade700,
                            fontWeight: FontWeight.w600),
                        floatingLabelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent.shade700,
                            fontWeight: FontWeight.w600,
                            height: 0.5),
                        contentPadding: const EdgeInsets.only(bottom: 10),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.cyan)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.cyan)),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese un usuario válido.' : null,
                    ),
                    const SizedBox(height: 45),
                    TextFormField(
                      cursorHeight: 22,
                      controller: passwordController,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.greenAccent.shade700, fontSize: 17),
                      decoration: InputDecoration(
                        isDense: true,
                        label: const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('Contraseña')),
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent.shade700,
                            fontWeight: FontWeight.w600),
                        floatingLabelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent.shade700,
                            fontWeight: FontWeight.w600,
                            height: 0.5),
                        contentPadding: const EdgeInsets.only(bottom: 10),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.cyan)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.cyan)),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Ingrese una contraseña válida.'
                          : null,
                    ),
                    const SizedBox(height: 35),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.bottomLeft,
                          radius: 4,
                          colors: <Color>[
                            Color(0xFF4284DB),
                            Color(0xFF29EAC4),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: MaterialButton(
                          child: const Text('Ingresar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          onPressed: () => submitIngresar()),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitIngresar() {
    if (formKey.currentState!.validate()) {
      if (usuarioController.text == 'admin' &&
          passwordController.text == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        Fluttertoast.showToast(
            msg: "Usuario o contraseña inválida.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
