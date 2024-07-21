import 'package:clinica_app/model/personal.dart';
import 'package:clinica_app/pages/home_page.dart';
import 'package:clinica_app/services/login_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Widget svgIcon = SvgPicture.asset('assets/image.svg',
      colorFilter: const ColorFilter.mode(Colors.greenAccent, BlendMode.srcIn));
  final Widget svgIcon2 = SvgPicture.asset('assets/image.svg',
      colorFilter: const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn));
  bool loader = false;

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
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent.shade700),
                      ),
                    ),
                    const SizedBox(height: 30),
                    inputForm('Usuario', usuarioController, context),
                    const SizedBox(height: 45),
                    inputForm('Contraseña', passwordController, context),
                    const SizedBox(height: 40),
                    buttonIngresar(context)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inputForm(
      String label, TextEditingController controller, BuildContext context) {
    return TextFormField(
      cursorHeight: 22,
      controller: controller,
      enableSuggestions: label == 'Contraseña' ? false : true,
      autocorrect: label == 'Contraseña' ? false : true,
      obscureText: label == 'Contraseña' ? true : false,
      style: TextStyle(color: Colors.greenAccent.shade700, fontSize: 16),
      textInputAction:
          label == 'Usuario' ? TextInputAction.next : TextInputAction.send,
      decoration: InputDecoration(
        isDense: true,
        label: Padding(
            padding: const EdgeInsets.only(bottom: 20), child: Text(label)),
        labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.blueAccent.shade700,
            fontWeight: FontWeight.w600),
        floatingLabelStyle: TextStyle(
            fontSize: 19,
            color: Colors.blueAccent.shade700,
            fontWeight: FontWeight.w600,
            height: 0.8),
        contentPadding: const EdgeInsets.only(bottom: 10),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.cyan)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.cyan)),
      ),
      onFieldSubmitted: (value) =>
          label == 'Contraseña' ? submitIngresar(context) : null,
      validator: (value) =>
          value!.isEmpty ? '${label.toLowerCase()} inválido.' : null,
    );
  }

  Widget buttonIngresar(BuildContext context) {
    return Container(
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
          child: !loader
              ? const Text('Ingresar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700))
              : const CircularProgressIndicator(),
          onPressed: () => submitIngresar(context)),
    );
  }

  void submitIngresar(BuildContext context) {
    if (formKey.currentState!.validate()) {
      setState(() => loader = true);
      FocusScope.of(context).unfocus();
      LoginDao()
          .login(usuarioController.text, passwordController.text)
          .then((value) {
        if (value != null) {
          if (value['tipo_personal'] == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(personal: Personal.fromLogin(value))));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(personal: Personal.fromLogin(value))));
          }
        } else {
          setState(() => loader = false);
          Fluttertoast.showToast(
              msg: "Usuario o contraseña incorrecta.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }
}
