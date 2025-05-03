// lib/controllers/auth_controller.dart
import 'dart:convert';

import 'package:game/data/user.dart';
import 'package:game/screens/home_page.dart';
import 'package:game/service/api_serveice.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();



  Future<void> register(String username, String password) async {
    isLoading.value = true;
    try {
      final result = await ApiService.registerUser(username, password);
      if (result['statusCode'] == 201) {
        user.value = User(username: username);
        Get.snackbar('Success', 'Registered successfully');
        Get.offAllNamed('/home');

        // Navigate to home or login
      } else {
        Get.snackbar('Error', result['body']['message'] ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server error');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> login(String username, String password) async {
    isLoading.value = true;
    final response = await ApiService.loginUser(username, password);

    if (response['statusCode'] == 200) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar('Login Failed', response['body']['message'] ?? 'Invalid credentials');
    }

    isLoading.value = false;
  }
}

