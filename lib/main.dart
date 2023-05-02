import 'package:addmental/ui/login_page.dart';
import 'package:addmental/ui/main_page.dart';
import 'package:addmental/ui/views/home_view.dart';
import 'package:addmental/ui/views/result_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'color_schemes.g.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false, colorScheme: darkColorScheme),
      initialRoute: MainPage.id,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (_) => const LoginPage(),
        ResultView.id: (_) => const ResultView(),
        HomeView.id: (_) => const HomeView(),
      },
      home: const MainPage(),
    );
  }
}
