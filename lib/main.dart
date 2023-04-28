import 'package:addmental/ui/login_page.dart';
import 'package:addmental/ui/main_page.dart';
import 'package:addmental/ui/views/result_view.dart';
import 'package:addmental/ui/views/tests/anxiety_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainPage.id,
      routes: {
        LoginPage.id: (_) => const LoginPage(),
        ResultView.id: (_) => const ResultView(),
      },
      home: const MainPage(),
    );
  }
}
