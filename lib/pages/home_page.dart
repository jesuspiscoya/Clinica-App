import 'package:clinica_app/pages/navbar_page.dart';
import 'package:clinica_app/pages/register_page.dart';
import 'package:clinica_app/pages/search_page.dart';
import 'package:clinica_app/pages/triage_page.dart';
import 'package:flutter/material.dart';
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
  int index = 0;
  late final NavbarPage navbarPage;
  final List<Widget> listPages = [
    const SearchPage(),
    const RegisterPage(),
    const TriagePAge(),
  ];

  @override
  void initState() {
    initializeDateFormatting('es-PE', '').then((value) =>
        formattedDate = DateFormat.yMMMMEEEEd('es-PE').format(DateTime.now()));
    navbarPage = NavbarPage(currentIndex: (i) => setState(() => index = i));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbarPage,
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
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
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
            listPages[index]
          ],
        ),
      ),
    );
  }
}
