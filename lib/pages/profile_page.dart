import 'package:animate_do/animate_do.dart';
import 'package:clinica_app/model/personal.dart';
import 'package:clinica_app/controller/personal_controller.dart';
import 'package:clinica_app/widgets/input_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  Personal personal;

  ProfilePage({super.key, required this.personal});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> formKeyActualizar = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    correoController.text = widget.personal.correo!;
    telefonoController.text = widget.personal.telefono!;
    direccionController.text = widget.personal.direccion!;

    return Column(
      children: [
        const SizedBox(height: 15),
        !selected
            ? SlideInLeft(
                duration: const Duration(milliseconds: 150),
                from: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Text(
                      'Mi Perfil',
                      style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      elevation: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: formKeyActualizar,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              widget.personal.tipoPersonal == '1'
                                  ? InputForm(
                                      label: 'Especialidad',
                                      active: false,
                                      initial: widget.personal.especialidad)
                                  : const SizedBox(),
                              widget.personal.tipoPersonal == '1'
                                  ? const SizedBox(height: 10)
                                  : const SizedBox(),
                              InputForm(
                                  label: 'Nombres',
                                  active: false,
                                  initial: widget.personal.nombres),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Apellidos',
                                  active: false,
                                  initial:
                                      '${widget.personal.apellidoPaterno} ${widget.personal.apellidoMaterno}'),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Fecha de Nacimiento',
                                  active: false,
                                  initial: widget.personal.fechaNacimiento),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Correo',
                                  active: true,
                                  inputController: correoController),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Teléfono',
                                  active: true,
                                  inputController: telefonoController),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Dirección',
                                  active: true,
                                  inputController: direccionController),
                              const SizedBox(height: 13),
                              buttonActualizar(() => submitActualizar())
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    buttonPassword(),
                  ],
                ),
              )
            : SlideInRight(
                duration: const Duration(milliseconds: 150),
                from: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    buttonRegresar(),
                    const SizedBox(height: 15),
                    const Text(
                      'Cambiar Contraseña',
                      style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      elevation: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: formKeyPassword,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 15),
                              InputForm(
                                  label: 'Nueva contraseña',
                                  active: true,
                                  password: true,
                                  inputController: passwordController),
                              const SizedBox(height: 10),
                              InputForm(
                                  label: 'Repita nueva contraseña',
                                  active: true,
                                  password: true,
                                  inputController: password2Controller),
                              const SizedBox(height: 13),
                              buttonActualizar(() => submitPassword())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget buttonActualizar(Function onActualizar) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3,
            colors: <Color>[
              Color.fromARGB(255, 108, 200, 236),
              Color.fromARGB(255, 35, 102, 189),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => onActualizar()),
        child: const Text('Actualizar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget buttonPassword() {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3,
            colors: <Color>[
              Color.fromARGB(255, 72, 235, 208),
              Color.fromARGB(255, 35, 189, 73),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => selected = true),
        child: const Text('Cambiar Contraseña',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget buttonRegresar() {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 1.7,
            colors: <Color>[
              Color.fromARGB(255, 72, 235, 208),
              Color.fromARGB(255, 35, 189, 73),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => selected = false),
        child: const Text('Regresar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void submitActualizar() {
    if (formKeyActualizar.currentState!.validate()) {
      Personal personal = Personal(
          codigo: widget.personal.codigo,
          correo: correoController.text,
          telefono: telefonoController.text,
          direccion: direccionController.text);
      PersonalController().actualizarPersonal(personal).then((value) {
        if (value != null) {
          showToast('Datos actualizados con éxito.', Colors.green);
          widget.personal = Personal.fromLogin(value);
        } else {
          showToast('Error al actualizar datos.', Colors.red);
        }
      });
    }
  }

  void submitPassword() {
    if (formKeyPassword.currentState!.validate()) {
      if (passwordController.text == password2Controller.text) {
        Personal personal = Personal(
          codigo: widget.personal.codigo,
          password: passwordController.text,
        );
        PersonalController().actualizarPassword(personal).then((value) {
          if (value) {
            showToast('Contraseña actualizada con éxito.', Colors.green);
            setState(() => selected = false);
            passwordController.clear();
            password2Controller.clear();
          } else {
            showToast('Error al actualizar contraseña.', Colors.red);
          }
        });
      } else {
        showToast('Las contraseñas no coinciden.', Colors.red);
      }
    }
  }

  void showToast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
