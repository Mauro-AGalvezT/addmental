import 'package:addmental/ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static String id = "main_view";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }else{
            return const LoginPage();
          }
        },
      ),
    );
  }
}
