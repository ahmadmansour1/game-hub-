import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
      checkAuthStatus();
  }
  void checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    await Future.delayed(Duration(seconds: 2));

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/home'); // Token exists, go to Home
    } else {
      Get.offAllNamed('/login'); // No token, go to Login/Register
    }
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
