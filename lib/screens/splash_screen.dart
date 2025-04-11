import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/game.jpg'),
            SizedBox(height: 20),
            // App Name with Glowing Effect
            Text(
              'PlayHub',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
                fontFamily: 'Roboto',
                shadows: [
                  Shadow(
                    blurRadius: 30.0,
                    color: Colors.blueAccent,
                    offset: Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.cyanAccent,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
