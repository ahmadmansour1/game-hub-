
import 'package:game/data/game_center.dart';
import 'package:game/data/user.dart';
import 'package:game/screens/admin_home_page.dart';  // Import AdminHomePage screen
import 'package:game/screens/home_page.dart';
import 'package:game/service/api_serveice.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();

  Future<void> register({
    required String username,
    required String password,
    required bool isAdmin,
    int? age,
    GameCenters? gameCenter,
  }) async {
    isLoading.value = true;
    try {
      final result = await ApiService.register(
        username: username,
        password: password,
        isAdmin: isAdmin,
        age: age,
        gameCenter: gameCenter,
      );

      if (result['statusCode'] == 201) {
        user.value = User(username: username);
        Get.snackbar('Success', 'Registered successfully');

        if (isAdmin) {
          // Navigate to admin home page
          Get.offAll(() => AdminHomePage());
        } else {
          // Navigate to regular home page
          Get.offAllNamed('/home');
        }
      } else {
        Get.snackbar('Error', result['body']['message'] ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String username, String password , bool isAdmin) async {
    isLoading.value = true;
    final response = await ApiService.loginUser(username, password);

    if (response['statusCode'] == 200) {
      // Assuming the login API returns user info including admin flag
      final body = response['body'];
      // final bool isAdmin = body['admin'] ?? false;

      if (isAdmin) {
        Get.offAll(() => AdminHomePage());
      } else {
        Get.offAll(() => HomeScreen());
      }
    } else {
      Get.snackbar('Login Failed', response['body']['message'] ?? 'Invalid credentials');
    }

    isLoading.value = false;
  }
}
