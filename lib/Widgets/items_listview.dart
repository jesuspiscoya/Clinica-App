import 'package:clinica_app/pages/login_page.dart';
import 'package:clinica_app/pages/register_page.dart';
import 'package:clinica_app/pages/search_page.dart';
import 'package:clinica_app/pages/triage_page.dart';
import 'package:flutter/material.dart';

class ItemsListView extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool active;
  final int? index;
  dynamic page;

  ItemsListView({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.active,
    this.index,
  });

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  final List<Widget> listPages = [
    const SearchPage(),
    const RegisterPage(),
    const TriagePAge(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20, bottom: 15),
        decoration: widget.active
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
        child: TextButton.icon(
          style: const ButtonStyle(
              alignment: Alignment.centerLeft,
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(30))))),
          icon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(widget.icon, size: 30, color: widget.color)),
          label: Padding(
              padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
              child: Text(widget.label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: widget.color))),
          onPressed: () => widget.index != null
              ? widget.page = listPages[widget.index!]
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage())),
        ));
  }
}
