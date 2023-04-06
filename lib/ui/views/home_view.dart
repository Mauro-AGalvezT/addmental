import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String id = "home_view";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser!;
  int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logeado ${user.email!}'),
        MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text('Cerrar sesión')),        
      ],
    )),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (value){
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
            //backgroundColor: Colors.primary
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
            //backgroundColor: Colors.primary
          ),          
          BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart_rounded),
                activeIcon: Icon(Icons.insert_chart_rounded),
                label: 'Resultados',
                //backgroundColor: Colors.primary
                )
        ])
    );
  }
}
