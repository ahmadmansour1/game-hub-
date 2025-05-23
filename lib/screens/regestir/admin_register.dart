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
      appBar: AppBar(
        title: const Text('Register Admin'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                'Admin Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Game Center Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: gameCenterNameController,
                        decoration: const InputDecoration(
                          labelText: 'Game Center Name',
                          prefixIcon: Icon(Icons.videogame_asset),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: numberOfRoomsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Number of Rooms',
                          prefixIcon: Icon(Icons.meeting_room),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Room Prices (per hour):",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...List.generate(priceControllers.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: TextField(
                                controller: priceControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Room ${index + 1} Price',
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      const SizedBox(height: 12),
                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: const Text(
                  'Register Admin',
                  style: TextStyle(fontSize: 16),
                ),
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
              )
            ],
          ),
        );
      }),
    );
  }

}
