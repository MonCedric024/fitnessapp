import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/splash_screen.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/providers/userdata.dart';


void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserData()),
          ChangeNotifierProvider(create: (_) => User()),

    ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

