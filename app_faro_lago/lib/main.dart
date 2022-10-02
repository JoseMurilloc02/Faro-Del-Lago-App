import 'package:app_faro_lago/Screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/init_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Paint.enableDithering = true;
  runApp(const InitApp());
}

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Administrador",
      routes: {
        "InitScreen": (context) => const InitScreen(),
        "MainScreen": (context) => const MainScreen(),
      },
      initialRoute: "InitScreen",
    );
  }
}
