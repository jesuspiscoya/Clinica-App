import 'package:flutter/material.dart';

class NavbarPage extends StatefulWidget {
  int index = 0;
  final Function currentIndex;

  NavbarPage({
    super.key,
    required this.currentIndex,
  });

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF131935),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Jesus Piscoya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            accountEmail: const Text('Médico',
                style: TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.w600)),
            currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/profile.png', fit: BoxFit.cover)),
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
          itemDrawer(Icons.person_add_alt_rounded, 'Registrar Paciente',
              Colors.white, 1),
          itemDrawer(
              Icons.monitor_heart_rounded, 'Registrar Triaje', Colors.white, 2),
          const SizedBox(height: 315),
          itemDrawer(Icons.logout_rounded, 'Salir', Colors.red.shade600, 3)
        ],
      ),
    );
  }

  Widget itemDrawer(IconData icon, String label, Color color, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 20),
      child: InkWell(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                  boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 10)])
              : null,
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon, size: 30, color: color),
              const SizedBox(width: 14),
              Text(label,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: color))
            ],
          ),
        ),
        onTap: () {
          setState(() {
            widget.index = index;
            widget.currentIndex(index);
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}
