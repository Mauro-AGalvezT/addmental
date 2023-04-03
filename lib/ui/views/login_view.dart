import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  static String id = "login_view";

  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(children: [
          SizedBox(height: 25),
          Text(
            '¡Bienvenido!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          //email texfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          //password texfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Contraseña',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
