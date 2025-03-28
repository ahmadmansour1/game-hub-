import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game/screens/splash_screen.dart';

import 'consts/api_keys.dart';
import 'service/firebase_options.dart';

void main() async {
  Stripe.publishableKey=ApiKeys.publishedKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        appBarTheme: AppBarTheme(
          elevation: 4.0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 24,
          ),
        ),
        useMaterial3: false
      ),

      home: SplashScreen(),
    );
  }
}
