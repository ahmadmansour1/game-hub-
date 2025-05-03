import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game/screens/home_page.dart';
import 'package:game/screens/login%20/login.dart';
import 'package:game/screens/regestir/register.dart';
import 'package:game/screens/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bindings/auth_bindings.dart';
import 'consts/api_keys.dart';
import 'service/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 Required for platform channels
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Optionally configure Stripe if you're using it
  Stripe.publishableKey = ApiKeys.publishedKey;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage(), binding: AuthBinding()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/register', page: () => RegisterPage(), binding: AuthBinding()),
      ],
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
      initialBinding: AuthBinding(),
      home: SplashScreen(),
    );
  }
}

