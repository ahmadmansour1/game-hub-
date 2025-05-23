// lib/services/api_service.dart
import 'package:game/data/game_center.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../consts/api_keys.dart';

class ApiService {

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required bool isAdmin,
    int? age,
    GameCenters? gameCenter,
  }) async {
    final url = Uri.parse('${ApiKeys.baseUrl}${ApiKeys.registerEndpoint}');

    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'admin': isAdmin,
    };

    if (isAdmin) {
      if (gameCenter != null) {
        body['gameCenter'] = gameCenter.toJson();
      }
    } else {
      body['age'] = age ?? 18;
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
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
  static Future<GameCenterModel?> getAllGameCenters() async {
    final url = Uri.parse('${ApiKeys.baseUrl}/getGameCenters'); // Ensure the endpoint matches your backend

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken() ?? ''}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return GameCenterModel.fromJson(data);
    } else {
      print('Failed to fetch game centers: ${response.body}');
      return null;
    }
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
