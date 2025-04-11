import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MockMapScreen extends StatelessWidget {
  const MockMapScreen({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> mockCenters = [
    {
      "name": "Galaxy Game Center",
      "distance": "1.2 km",
      "rating": 4.5,
      "isBusy": false,
      "availableRooms": 3,
      "location": LatLng(40.7138, -74.0060),
    },
    {
      "name": "Epic Play Arena",
      "distance": "2.4 km",
      "rating": 4.8,
      "isBusy": true,
      "availableRooms": 0,
      "location": LatLng(40.7120, -74.0010),
    },
    {
      "name": "Next Level Hub",
      "distance": "3.1 km",
      "rating": 4.2,
      "isBusy": false,
      "availableRooms": 5,
      "location": LatLng(40.7100, -74.0100),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mock Map")),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.7128, -74.0060), // NYC center
          initialZoom: 13.0,
          interactionOptions: const InteractionOptions(
            enableMultiFingerGestureRace: true,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: mockCenters.map((center) {
              final LatLng location = center['location'];
              return Marker(
                width: 80,
                height: 80,
                point: location,
                child: Column(
                  children: [
                    const Icon(Icons.location_pin, size: 36, color: Colors.red),
                    Text(
                      center["name"],
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

