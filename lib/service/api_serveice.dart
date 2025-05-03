// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../consts/api_keys.dart';

class ApiService {
  static Future<Map<String, dynamic>> registerUser(String username, String password) async {
    final url = Uri.parse('${ApiKeys.baseUrl}${ApiKeys.registerEndpoint}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final url = Uri.parse('${ApiKeys.baseUrl}${ApiKeys.loginEndpoint}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['token'] != null) {
      await saveToken(responseBody['token']);
    }

    return {
      'statusCode': response.statusCode,
      'body': responseBody,
    };
  }

  // Save token to SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Clear token (optional: logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
