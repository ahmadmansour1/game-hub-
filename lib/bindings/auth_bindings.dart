// lib/bindings/auth_binding.dart
import 'package:game/controllers/auth_controllers.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
