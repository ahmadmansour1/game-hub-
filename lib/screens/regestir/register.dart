// lib/views/register_page.dart
import 'package:flutter/material.dart';
import 'package:game/controllers/auth_controllers.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Obx(() {
        return authController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.register(
                   username:  usernameController.text.trim(),
                  password:   passwordController.text.trim(),
                   isAdmin: false);
                },
                child: Text('Register'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
