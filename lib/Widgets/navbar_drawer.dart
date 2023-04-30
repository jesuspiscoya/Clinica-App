import 'package:clinica_app/model/enfermera.dart';
import 'package:clinica_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class NavbarDrawer extends StatefulWidget {
  int index = 0;
  final Enfermera enfermera;
  final Function currentIndex;

  NavbarDrawer({
    super.key,
    required this.enfermera,
    required this.currentIndex,
  });

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF131935),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
                '${widget.enfermera.nombres} ${widget.enfermera.apellidoPaterno}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            accountEmail: const Text('Personal de Salud',
                style: TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.w600)),
            currentAccountPicture: const CircleAvatar(
                // child: Image.asset('assets/profile.png', fit: BoxFit.cover)),
                child: Icon(Icons.person_rounded, size: 55)),
            decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 2,
                  colors: <Color>[
                    Color(0xFF4284DB),
                    Color(0xFF29EAC4),
                  ],
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
          ),
          const SizedBox(height: 10),
          itemDrawer(
              Icons.person_search_rounded, 'Buscar Paciente', Colors.white, 0),
          const SizedBox(height: 15),
          itemDrawer(Icons.person_add_alt_rounded, 'Registrar Paciente',
              Colors.white, 1),
          const SizedBox(height: 15),
          itemDrawer(
              Icons.monitor_heart_rounded, 'Registrar Triaje', Colors.white, 2),
          const SizedBox(height: 15),
          itemDrawer(Icons.person_rounded, 'Perfil', Colors.white, 3),
          const Expanded(child: SizedBox()),
          const Divider(thickness: 0.3, color: Colors.white),
          itemDrawer(Icons.logout_rounded, 'Salir', Colors.red.shade600, 4),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget itemDrawer(IconData icon, String label, Color color, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: widget.index == index
              ? const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: 6,
                    colors: <Color>[
                      Color(0xFF4284DB),
                      Color(0xFF29EAC4),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 8)])
              : null,
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon, size: 26, color: color),
              const SizedBox(width: 14),
              Text(label,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: color))
            ],
          ),
        ),
        onTap: () {
          index < 4
              ? setState(() {
                  widget.index = index;
                  widget.currentIndex(index);
                  Navigator.of(context).pop();
                })
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
        },
      ),
    );
  }
}
