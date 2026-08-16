import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  final MapController _mapController = MapController();

  LatLng currentLocation = const LatLng(27.7172, 85.3240);

  final List<Map<String, String>> hospitals = const [
    {"name": "Bir Hospital", "address": "Kathmandu", "phone": "01-4221119"},
    {
      "name": "Teaching Hospital",
      "address": "Maharajgunj, Kathmandu",
      "phone": "01-4412303",
    },
    {
      "name": "Patan Hospital",
      "address": "Lagankhel, Lalitpur",
      "phone": "01-5522278",
    },
  ];

  final List<LatLng> hospitalLocations = const [
    LatLng(27.7172, 85.3240), // Bir Hospital
    LatLng(27.7355, 85.3310), // Teaching Hospital
    LatLng(27.6845, 85.3129), // Patan Hospital
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(currentLocation, 13);
    });
  }

  Future<void> _callHospital(String name, String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unable to call $name")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "📍 Hospitals Near You",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // MAP
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 300,
              child: FlutterMap(
                mapController: _mapController,

                options: MapOptions(
                  initialCenter: currentLocation,
                  initialZoom: 13,
                ),

                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: "com.example.smart_ambulance_app",
                  ),

                  MarkerLayer(
                    markers: [
                      // USER LOCATION
                      Marker(
                        point: currentLocation,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),

                      // HOSPITAL MARKERS
                      ...List.generate(hospitals.length, (index) {
                        return Marker(
                          point: hospitalLocations[index],
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(hospitals[index]["name"]!),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.local_hospital,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // HOSPITAL LIST
          ...List.generate(hospitals.length, (index) {
            final hospital = hospitals[index];

            return Card(
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hospital["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                hospital["address"]!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),

                        const SizedBox(width: 10),

                        Text(hospital["phone"]!),

                        const Spacer(),

                        ElevatedButton.icon(
                          onPressed: () {
                            _callHospital(
                              hospital["name"]!,
                              hospital["phone"]!,
                            );
                          },

                          icon: const Icon(Icons.call),

                          label: const Text("Call"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
