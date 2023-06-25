import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../util/color_schemes.g.dart';

class HomeView extends StatefulWidget {
  static String id = "home_view";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Estamos para ayudarte',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: darkColorScheme.secondaryContainer,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Si sientes un gran miedo, una angustia constante o si te sientes con una fuerte desmotivación hacia lo que sueles hacer día a día.'
                              'Te invitamos a probar nuestros Test para averiguar sitienes depresión, ansiedad o ambos.',
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                'assets/images/image1.jpg',
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )),
      
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: darkColorScheme.secondaryContainer,
                        ),
                      child: Column(
                        children: [
                          const Text(
                            'Para conocer el resultado de sus Test presione el siguiente botón o el botón de la de derecha en la barra de acceso rápido.',
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/images/image2.jpg',
                              width: 230,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
