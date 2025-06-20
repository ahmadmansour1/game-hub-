import 'package:flutter/material.dart';
import 'package:game/controllers/auth_controllers.dart';
import 'package:game/screens/regestir/register.dart';
import 'package:get/get.dart';

import '../regestir/admin_register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => authController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/game.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Main content with logo and login form
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.01), // Top spacing

                  // Logo Image on top
                  Center(
                    child: Image.asset(
                      'assets/Screenshot.png',
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.25,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Admin/User Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Register as: "),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text('User'),
                              selected: !isAdmin,
                              onSelected: (_) {
                                setState(() {
                                  isAdmin = false;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text('Admin'),
                              selected: isAdmin,
                              onSelected: (_) {
                                setState(() {
                                  isAdmin = true;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              authController.login(username, password , isAdmin);
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            if (isAdmin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterAdminPage()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            }
                          },
                          child: const Text("Don't have an account? Register"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
