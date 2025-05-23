import 'package:flutter/material.dart';
import 'package:game/controllers/auth_controllers.dart';
import 'package:game/data/game_center.dart';
import 'package:get/get.dart';

class RegisterAdminPage extends StatefulWidget {
  @override
  State<RegisterAdminPage> createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final gameCenterNameController = TextEditingController();
  final numberOfRoomsController = TextEditingController();
  final locationController = TextEditingController();
  final List<TextEditingController> priceControllers = List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    gameCenterNameController.dispose();
    numberOfRoomsController.dispose();
    locationController.dispose();
    priceControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('Register Admin')),
      body: Obx(() {
        return authController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Text('Game Center Details', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: gameCenterNameController,
                decoration: InputDecoration(labelText: 'Game Center Name'),
              ),
              TextField(
                controller: numberOfRoomsController,
                decoration: InputDecoration(labelText: 'Number of Rooms'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ...List.generate(priceControllers.length, (index) {
                return TextField(
                  controller: priceControllers[index],
                  decoration: InputDecoration(labelText: 'Price/hour for Room ${index + 1}'),
                  keyboardType: TextInputType.number,
                );
              }),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final prices = List.generate(priceControllers.length, (index) {
                    return Prices(
                      roomNumber: index + 1,
                      pricePerHour: int.tryParse(priceControllers[index].text.trim()) ?? 0,
                    );
                  });

                  final gameCenter = GameCenters(
                    name: gameCenterNameController.text.trim(),
                    numberOfRooms: int.tryParse(numberOfRoomsController.text.trim()) ?? 0,
                    location: locationController.text.trim(),
                    prices: prices,
                  );

                  authController.register(
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                    isAdmin: true,
                    gameCenter: gameCenter,
                  );
                },
                child: Text('Register Admin'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
