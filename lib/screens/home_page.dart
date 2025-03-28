import 'package:flutter/material.dart';
import 'package:game/service/payment_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> mockCenters = const [
    {
      "name": "Galaxy Game Center",
      "distance": "1.2 km",
      "rating": 4.5,
      "isBusy": false,
      "availableRooms": 3,
    },
    {
      "name": "Epic Play Arena",
      "distance": "2.4 km",
      "rating": 4.8,
      "isBusy": true,
      "availableRooms": 0,
    },
    {
      "name": "Next Level Hub",
      "distance": "3.1 km",
      "rating": 4.2,
      "isBusy": false,
      "availableRooms": 5,
    },
  ];

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
                  // Location & Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                            children: const [
                              Icon(Icons.location_on, color: Colors.red),
                              SizedBox(width: 4),
                              Text(
                                "Near: Downtown",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Profile Icon
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Game Center List
            Expanded(
              child: ListView.builder(
                itemCount: mockCenters.length,
                itemBuilder: (context, index) {
                  final center = mockCenters[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        center["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${center["distance"]} • ⭐ ${center["rating"]}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          if (center["isBusy"])
                            const Text(
                              "🚫 Busy",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            )
                          else
                            Text(
                              "✅ Rooms Left: ${center["availableRooms"]}",
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: center["isBusy"]
                            ? null // Disable button if busy
                            : () async {
                       await PaymentManager.makePayment(10, "usd");


                        },
                        child: const Text("Book Now"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to map view
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}

