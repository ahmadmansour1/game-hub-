// lib/services/api_service.dart
import 'package:game/data/booking.dart';
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
  static Future<Map<String, dynamic>> loginUser(String username, String password , bool isAdmin   ) async {
    final url = Uri.parse('${ApiKeys.baseUrl}${ApiKeys.loginEndpoint}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['token'] != null) {

      await saveToken(responseBody['token'] , isAdmin);

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
  static Future<List<BookingModel>> getBookings() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/bookings/game-center');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken() ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> bookingsJson = json['bookings'];

      return bookingsJson.map((b) => BookingModel.fromJson(b)).toList();
    } else {
      print('Failed to fetch bookings: ${response.body}');
      return [];
    }
  }
  static Future<bool> updateBookingStatus(String bookingId, String status) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/bookings/$bookingId/status');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken() ?? ''}',
      },
      body: jsonEncode({"status": status}),
    );

    return response.statusCode == 200;
  }
 static  Future<bool> createBooking({
    required String userId,
    required String gameCenterId,
    required int roomNumber,
    required String startTime,
    required String endTime,
    required double price,
    required String date,
  }) async {
    final url = Uri.parse('http://your-server-url/api/bookings/createBookings');

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': userId,
          'gameCenter': gameCenterId,
          'roomNumber': roomNumber,
          'startTime': startTime,
          'endTime': endTime,
          'price': price,
          'date': date,
          'status': 'paid', // since payment succeeded
        }));

    if (response.statusCode == 201) {
      return true; // success
    } else {
      print('Booking creation failed: ${response.body}');
      return false;
    }
  }
  // Save token to SharedPreferences
  static Future<void> saveToken(String token , bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setBool('isAdmin', isAdmin);

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
