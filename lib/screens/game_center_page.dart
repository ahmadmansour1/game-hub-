import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game/controllers/game_center_controller.dart';
import 'package:game/data/game_center.dart';
import 'package:game/service/payment_service.dart';

class GameCenterPage extends StatefulWidget {
  GameCenterPage({Key? key}) : super(key: key);

  @override
  State<GameCenterPage> createState() => _GameCenterPageState();
}

class _GameCenterPageState extends State<GameCenterPage> {
  final GameCenterController controller = Get.put(GameCenterController());

  // Search query as an observable string
  final RxString searchQuery = "".obs;

  // Filtered list depending on search query
  List<GameCenters> get filteredGameCenters {
    if (searchQuery.value.isEmpty) return controller.gameCenters;
    return controller.gameCenters
        .where((center) =>
        center.name!.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    controller.fetchGameCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & Profile Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final nearLocation = controller.gameCenters.isNotEmpty
                            ? controller.gameCenters.first.location
                            : "Downtown";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome, Ahmad!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  "Near: $nearLocation",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar (no Obx here, reacts via onChanged)
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search for game centers...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => searchQuery.value = val,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Game Center List or Loading Indicator
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredList = filteredGameCenters;

                if (filteredList.isEmpty) {
                  return const Center(child: Text("No game centers found."));
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final center = filteredList[index];

                    final pricePerHour = center.prices!.isNotEmpty
                        ? center.prices!.first.pricePerHour
                        : 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          center.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center.location!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rooms: ${center.numberOfRooms} • Price/hr: \$${pricePerHour.toString()}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            await PaymentManager.makePayment(pricePerHour!, "usd");
                          },
                          child: const Text("Book Now"),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to map view
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
