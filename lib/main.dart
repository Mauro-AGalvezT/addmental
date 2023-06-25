import 'package:addmental/services/location_service.dart';
import 'package:addmental/ui/login_page.dart';
import 'package:addmental/ui/main_page.dart';
import 'package:addmental/ui/views/home_view.dart';
import 'package:addmental/ui/views/result_view.dart';
import 'package:addmental/ui/views/results/result_prediction_view.dart';
import 'package:addmental/ui/views/test_view.dart';
import 'package:addmental/ui/views/tests/anxiety_view.dart';
import 'package:addmental/ui/views/tests/depression_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'util/color_schemes.g.dart';
import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  static String id = "main_view";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocationService.init();
    return MaterialApp(
      title: 'AddMental',
      theme: ThemeData(useMaterial3: false, colorScheme: darkColorScheme),
      initialRoute: MainPage.id,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (_) => const LoginPage(),
        ResultView.id: (_) => const ResultView(),
        TestView.id: (_) => const TestView(),
        HomeView.id: (_) => const HomeView(),
        DepressionView.id: (_) => const DepressionView(),
        AnxietyView.id: (_) => const AnxietyView(),
        //ResultTestView.id: (_) => const ResultTestView(),
        ResultPredictionView.id: (_) => const ResultPredictionView(),
      },
      home: const MainPage(),
    );
  }
}
