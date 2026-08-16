import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../models/hospital.dart';
import '../services/route_service.dart';

class RequestAmbulanceScreen extends StatefulWidget {
  const RequestAmbulanceScreen({super.key});

  @override
  State<RequestAmbulanceScreen> createState() => _RequestAmbulanceScreenState();
}

class _RequestAmbulanceScreenState extends State<RequestAmbulanceScreen> {
  final MapController _mapController = MapController();

  LatLng currentLocation = const LatLng(27.7172, 85.3240);

  LatLng ambulanceLocation = const LatLng(27.7100, 85.3200);
  List<LatLng> routePoints = [];

  List<LatLng> hospitalRoutePoints = [];

  bool goingToHospital = false;

  int hospitalRouteIndex = 0;

  Timer? hospitalTimer;
  Timer? ambulanceTimer;

  int currentRouteIndex = 0;

  Hospital? nearestHospital;

  double nearestDistance = 0;

  bool ambulanceMoving = false;

  bool ambulanceRequested = false;

  int journeyStep = 0;

  String ambulanceStatus = "Available";

  String driverName = "Ram Sharma";
  String driverPhone = "+977-9812345678";
  String ambulanceNumber = "BA 2 CHA 4567";

  double remainingDistance = 0;
  int etaMinutes = 0;
  double ambulanceSpeed = 40;

  final List<Hospital> hospitals = [
    Hospital(name: "Bir Hospital", location: const LatLng(27.7172, 85.3240)),
    Hospital(
      name: "Teaching Hospital",
      location: const LatLng(27.7355, 85.3310),
    ),
    Hospital(name: "Patan Hospital", location: const LatLng(27.6845, 85.3129)),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    ambulanceTimer?.cancel();
    hospitalTimer?.cancel();
    super.dispose();
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

    currentLocation = LatLng(position.latitude, position.longitude);

    _findNearestHospital();

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(currentLocation, 16);
    });
  }

  Future<void> _loadRoute() async {
    routePoints = await RouteService.getRoute(
      ambulanceLocation,
      currentLocation,
    );

    // Estimate distance and ETA
    remainingDistance = routePoints.length * 0.02;

    etaMinutes = (remainingDistance / 0.5).ceil();

    setState(() {});

    _startAmbulance();
  }

  void _startAmbulance() {
    if (routePoints.isEmpty) return;

    ambulanceStatus = "On the way";
    journeyStep = 2;
    ambulanceMoving = true;
    currentRouteIndex = 0;

    ambulanceTimer?.cancel();

    ambulanceTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      // Ambulance reached patient
      if (currentRouteIndex >= routePoints.length) {
        timer.cancel();

        setState(() {
          ambulanceMoving = false;
          ambulanceStatus = "Arrived";
          journeyStep = 3;
        });

        // Wait 3 seconds → patient is picked up
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;

          setState(() {
            journeyStep = 4;
            ambulanceStatus = "Patient Picked";
          });

          // Start actual journey to hospital
          _startHospitalJourney();
        });

        return;
      }

      setState(() {
        ambulanceLocation = routePoints[currentRouteIndex];

        remainingDistance = (routePoints.length - currentRouteIndex) * 0.02;

        if (remainingDistance < 0) {
          remainingDistance = 0;
        }

        etaMinutes = (remainingDistance / 0.5).ceil();

        ambulanceSpeed = 35 + (currentRouteIndex % 6) * 3;
      });

      currentRouteIndex++;
    });
  }

  void _startHospitalJourney() async {
    if (nearestHospital == null) return;

    // Get route from patient to nearest hospital
    hospitalRoutePoints = await RouteService.getRoute(
      currentLocation,
      nearestHospital!.location,
    );

    if (hospitalRoutePoints.isEmpty) return;

    setState(() {
      ambulanceMoving = true;
      ambulanceStatus = "Going to Hospital";
      journeyStep = 4;
      hospitalRouteIndex = 0;
    });

    hospitalTimer?.cancel();

    hospitalTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      // Ambulance reached hospital
      if (hospitalRouteIndex >= hospitalRoutePoints.length) {
        timer.cancel();

        setState(() {
          ambulanceLocation = nearestHospital!.location;
          ambulanceMoving = false;
          ambulanceStatus = "Reached Hospital";
          journeyStep = 5;
          remainingDistance = 0;
          etaMinutes = 0;
        });

        return;
      }

      setState(() {
        ambulanceLocation = hospitalRoutePoints[hospitalRouteIndex];

        remainingDistance =
            (hospitalRoutePoints.length - hospitalRouteIndex) * 0.02;

        if (remainingDistance < 0) {
          remainingDistance = 0;
        }

        etaMinutes = (remainingDistance / 0.5).ceil();

        ambulanceSpeed = 35 + (hospitalRouteIndex % 6) * 3;
      });

      hospitalRouteIndex++;
    });
  }

  void _findNearestHospital() {
    double shortest = double.infinity;

    for (Hospital hospital in hospitals) {
      double distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        hospital.location.latitude,
        hospital.location.longitude,
      );

      if (distance < shortest) {
        shortest = distance;
        nearestHospital = hospital;
      }
    }

    nearestDistance = shortest / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Request Ambulance"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Emergency Request",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Request the nearest available ambulance.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            const Text(
              "📍 Current Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(15),

              child: SizedBox(
                height: 300,

                child: FlutterMap(
                  mapController: _mapController,

                  options: MapOptions(
                    initialCenter: currentLocation,
                    initialZoom: 15,
                  ),

                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.smart_ambulance_app",
                    ),

                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          if (routePoints.isNotEmpty)
                            Polyline(
                              points: routePoints,
                              strokeWidth: 5,
                              color: Colors.blue,
                            ),

                          if (hospitalRoutePoints.isNotEmpty)
                            Polyline(
                              points: hospitalRoutePoints,
                              strokeWidth: 5,
                              color: Colors.green,
                            ),
                        ],
                      ),

                    MarkerLayer(
                      markers: [
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

                        Marker(
                          point: ambulanceLocation,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.blue,
                            size: 42,
                          ),
                        ),

                        ...hospitals.map(
                          (hospital) => Marker(
                            point: hospital.location,
                            width: 45,
                            height: 45,
                            child: const Icon(
                              Icons.local_hospital,
                              color: Colors.green,
                              size: 38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.local_hospital, color: Colors.white),
                ),
                title: const Text(
                  "Nearest Hospital",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  nearestHospital == null
                      ? "Searching..."
                      : "${nearestHospital!.name}\n${nearestDistance.toStringAsFixed(2)} km away",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ambulanceMoving ? Colors.orange : Colors.red,
                  child: const Icon(Icons.local_shipping, color: Colors.white),
                ),
                title: const Text(
                  "Ambulance Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ambulanceStatus),
              ),
            ),
            const SizedBox(height: 15),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🚑 Ambulance Tracking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Remaining Distance"),
                        Text("${remainingDistance.toStringAsFixed(2)} km"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Estimated Arrival"),
                        Text("$etaMinutes min"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Speed"),
                        Text("${ambulanceSpeed.toStringAsFixed(0)} km/h"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Current Location"),
                        Expanded(
                          child: Text(
                            "${ambulanceLocation.latitude.toStringAsFixed(4)}, ${ambulanceLocation.longitude.toStringAsFixed(4)}",
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Live Status"),
                        Text(
                          ambulanceStatus,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (ambulanceRequested)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🚑 Ambulance Journey",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildJourneyStep(
                        step: 1,
                        title: "Request Sent",
                        icon: Icons.send,
                      ),

                      _buildJourneyLine(),

                      _buildJourneyStep(
                        step: 2,
                        title: "Ambulance On The Way",
                        icon: Icons.local_shipping,
                      ),

                      _buildJourneyLine(),

                      _buildJourneyStep(
                        step: 3,
                        title: "Arrived",
                        icon: Icons.location_on,
                      ),

                      _buildJourneyLine(),

                      _buildJourneyStep(
                        step: 4,
                        title: "Patient Picked",
                        icon: Icons.person,
                      ),

                      _buildJourneyLine(),

                      _buildJourneyStep(
                        step: 5,
                        title: "Reached Hospital",
                        icon: Icons.local_hospital,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 15),

            if (ambulanceRequested)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "👨 Driver Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(driverName),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.green),
                          const SizedBox(width: 10),
                          Text(driverPhone),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.local_shipping, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(ambulanceNumber),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (ambulanceMoving)
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                color: Colors.red,
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_hospital),

                label: Text(
                  ambulanceMoving ? "AMBULANCE COMING..." : "REQUEST AMBULANCE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: ambulanceMoving
                    ? null
                    : () async {
                        ambulanceRequested = true;
                        journeyStep = 1;
                        ambulanceStatus = "Finding Ambulance...";

                        setState(() {});

                        await _loadRoute();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Ambulance Request Sent Successfully!",
                            ),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyStep({
    required int step,
    required String title,
    required IconData icon,
  }) {
    final bool completed = journeyStep >= step;
    final bool current = journeyStep == step;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: completed ? Colors.green : Colors.grey.shade300,
          child: Icon(
            completed ? Icons.check : icon,
            color: completed ? Colors.white : Colors.grey,
            size: 22,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: current ? FontWeight.bold : FontWeight.normal,
              color: completed ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyLine() {
    return Container(
      margin: const EdgeInsets.only(left: 19),
      height: 30,
      width: 2,
      color: journeyStep > 0 ? Colors.green : Colors.grey.shade300,
    );
  }
}
