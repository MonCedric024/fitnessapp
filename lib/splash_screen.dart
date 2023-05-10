import 'dart:async';
import 'package:fitnessapp/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => InitState();
  }

class InitState extends State<SplashScreen> {


  @override
  void initState(){
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, loginRoute);
  }

  loginRoute() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  LoginScreen()
        ));
  }
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xff004AAD),
                gradient: LinearGradient(
                  colors: [(Color(0xff004AAD)), (Color(0xff004AAD))],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.3,
                      width: constraints.maxHeight * 0.3,
                      child: Image.asset("assets/images/logo.jpg"),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
