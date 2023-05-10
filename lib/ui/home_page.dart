import 'package:addmental/ui/views/home_view.dart';
import 'package:addmental/ui/views/result_view.dart';
import 'package:addmental/ui/views/test_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "home_view";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  final screens = [const TestView(), const HomeView(),  const ResultView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
        appBar: AppBar(
          title: const Text('¡Bienvenido!'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'logout':
                    FirebaseAuth.instance.signOut();
                    break;
                  default:
                    return;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Cerrar Sesión'),
                  ),
                ];
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                activeIcon: Icon(Icons.book),
                label: 'Test',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart_rounded),
                activeIcon: Icon(Icons.insert_chart_rounded),
                label: 'Resultados',
              )
            ]));
  }
}
