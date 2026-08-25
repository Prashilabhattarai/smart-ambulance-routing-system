import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hospital.dart';
import '../services/route_service.dart';

class RequestAmbulanceScreen extends StatefulWidget {
  const RequestAmbulanceScreen({super.key});

  @override
  State<RequestAmbulanceScreen> createState() => _RequestAmbulanceScreenState();
}

class _RequestAmbulanceScreenState extends State<RequestAmbulanceScreen> {
  final MapController _mapController = MapController();

  // ---------------- COLORS ----------------

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  // ---------------- LOCATION ----------------

  LatLng currentLocation = const LatLng(27.7172, 85.3240);

  LatLng ambulanceLocation = const LatLng(27.7100, 85.3200);

  List<LatLng> routePoints = [];
  List<LatLng> hospitalRoutePoints = [];

  // ---------------- HOSPITAL ----------------

  Hospital? nearestHospital;
  double nearestDistance = 0;

  final List<Hospital> hospitals = [
    Hospital(name: "Bir Hospital", location: const LatLng(27.7172, 85.3240)),
    Hospital(
      name: "Teaching Hospital",
      location: const LatLng(27.7355, 85.3310),
    ),
    Hospital(name: "Patan Hospital", location: const LatLng(27.6845, 85.3129)),
  ];

  // ---------------- AMBULANCE ----------------

  bool ambulanceMoving = false;
  bool ambulanceRequested = false;
  bool goingToHospital = false;

  String ambulanceStatus = "Available";

  String driverName = "Ram Sharma";
  String driverPhone = "+977-9812345678";
  String ambulanceNumber = "BA 2 CHA 4567";

  // ---------------- JOURNEY ----------------

  int journeyStep = 0;

  int currentRouteIndex = 0;
  int hospitalRouteIndex = 0;

  Timer? ambulanceTimer;
  Timer? hospitalTimer;

  // ---------------- TRACKING ----------------

  double remainingDistance = 0;
  int etaMinutes = 0;
  double ambulanceSpeed = 40;

  // ---------------- AMBULANCE TYPE ----------------

  String selectedAmbulanceType = "Basic";

  final List<Map<String, dynamic>> ambulanceTypes = [
    {
      "name": "Basic",
      "subtitle": "Standard care",
      "icon": Icons.local_shipping_rounded,
    },
    {
      "name": "ICU",
      "subtitle": "Critical care",
      "icon": Icons.medical_services_rounded,
    },
    {
      "name": "Cardiac",
      "subtitle": "Heart care",
      "icon": Icons.favorite_rounded,
    },
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

  // =========================================================
  // LOCATION
  // =========================================================

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

    if (mounted) {
      setState(() {});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(currentLocation, 16);
    });
  }

  // =========================================================
  // FIND NEAREST HOSPITAL
  // =========================================================

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

  // =========================================================
  // LOAD ROUTE
  // =========================================================

  Future<void> _loadRoute() async {
    routePoints = await RouteService.getRoute(
      ambulanceLocation,
      currentLocation,
    );

    remainingDistance = routePoints.length * 0.02;

    etaMinutes = (remainingDistance / 0.5).ceil();

    if (mounted) {
      setState(() {});
    }

    _startAmbulance();
  }

  // =========================================================
  // START AMBULANCE
  // =========================================================

  void _startAmbulance() {
    if (routePoints.isEmpty) return;

    ambulanceStatus = "On the way";
    journeyStep = 2;
    ambulanceMoving = true;
    currentRouteIndex = 0;

    ambulanceTimer?.cancel();

    ambulanceTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (currentRouteIndex >= routePoints.length) {
        timer.cancel();

        setState(() {
          ambulanceMoving = false;
          ambulanceStatus = "Arrived";
          journeyStep = 3;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;

          setState(() {
            journeyStep = 4;
            ambulanceStatus = "Patient Picked";
          });

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

  // =========================================================
  // HOSPITAL JOURNEY
  // =========================================================

  Future<void> _startHospitalJourney() async {
    if (nearestHospital == null) return;

    hospitalRoutePoints = await RouteService.getRoute(
      currentLocation,
      nearestHospital!.location,
    );

    if (hospitalRoutePoints.isEmpty) {
      return;
    }

    setState(() {
      ambulanceMoving = true;
      ambulanceStatus = "Going to Hospital";
      journeyStep = 4;
      hospitalRouteIndex = 0;
      goingToHospital = true;
    });

    hospitalTimer?.cancel();

    hospitalTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
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

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 0,

        title: const Text(
          "Request Ambulance",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // MAP
              // =================================================
              _buildMap(),

              const SizedBox(height: 16),

              // =================================================
              // PICKUP
              // =================================================
              _buildLocationCard(),

              const SizedBox(height: 18),

              // =================================================
              // BEFORE REQUEST
              // =================================================
              if (!ambulanceRequested) ...[
                const Text(
                  "Choose ambulance type",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 10),

                _buildAmbulanceTypes(),

                const SizedBox(height: 18),

                _buildHospitalCard(),

                const SizedBox(height: 20),
              ],

              // =================================================
              // AFTER REQUEST
              // =================================================
              if (ambulanceRequested) ...[
                _buildTrackingCard(),

                const SizedBox(height: 14),

                _buildDriverCard(),

                const SizedBox(height: 14),

                _buildJourneyCard(),

                const SizedBox(height: 18),
              ],

              // =================================================
              // PROGRESS
              // =================================================
              if (ambulanceMoving) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),

                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: border,
                    color: primaryBlue,
                  ),
                ),

                const SizedBox(height: 16),
              ],

              // =================================================
              // MAIN BUTTON
              // =================================================
              _buildRequestButton(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // MAP
  // =========================================================

  Widget _buildMap() {
    return Container(
      height: 300,
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: FlutterMap(
          mapController: _mapController,

          options: MapOptions(initialCenter: currentLocation, initialZoom: 15),

          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.smart_ambulance_app',
            ),

            // ROUTES
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: primaryBlue,
                  ),

                  if (hospitalRoutePoints.isNotEmpty)
                    Polyline(
                      points: hospitalRoutePoints,
                      strokeWidth: 5,
                      color: medicalTeal,
                    ),
                ],
              ),

            // MARKERS
            MarkerLayer(
              markers: [
                // USER
                Marker(
                  point: currentLocation,
                  width: 50,
                  height: 50,

                  child: _mapMarker(
                    Icons.person_pin_circle_rounded,
                    primaryBlue,
                  ),
                ),

                // AMBULANCE
                Marker(
                  point: ambulanceLocation,
                  width: 50,
                  height: 50,

                  child: _mapMarker(Icons.local_shipping_rounded, primaryBlue),
                ),

                // HOSPITALS
                ...hospitals.map((hospital) {
                  return Marker(
                    point: hospital.location,
                    width: 45,
                    height: 45,

                    child: const Icon(
                      Icons.local_hospital_rounded,
                      color: medicalTeal,
                      size: 32,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapMarker(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.16), blurRadius: 8),
        ],
      ),

      child: Icon(icon, color: color, size: 34),
    );
  }

  // =========================================================
  // LOCATION CARD
  // =========================================================

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.location_on_rounded, color: primaryBlue),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Pickup location",
                  style: TextStyle(fontSize: 11, color: secondaryText),
                ),

                SizedBox(height: 3),

                Text(
                  "Current location",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.my_location_rounded, color: primaryBlue, size: 20),
        ],
      ),
    );
  }

  // =========================================================
  // AMBULANCE TYPES
  // =========================================================

  Widget _buildAmbulanceTypes() {
    return Row(
      children: ambulanceTypes.map((type) {
        final bool selected = selectedAmbulanceType == type["name"];

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedAmbulanceType = type["name"];
              });
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              margin: const EdgeInsets.only(right: 8),

              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),

              decoration: BoxDecoration(
                color: selected ? primaryBlue : Colors.white,

                borderRadius: BorderRadius.circular(15),

                border: Border.all(color: selected ? primaryBlue : border),
              ),

              child: Column(
                children: [
                  Icon(
                    type["icon"],
                    size: 25,
                    color: selected ? Colors.white : primaryBlue,
                  ),

                  const SizedBox(height: 7),

                  Text(
                    type["name"],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : darkText,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    type["subtitle"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================================================
  // HOSPITAL CARD
  // =========================================================

  Widget _buildHospitalCard() {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: medicalTeal.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.local_hospital_rounded, color: medicalTeal),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Nearest hospital",
                  style: TextStyle(fontSize: 11, color: secondaryText),
                ),

                const SizedBox(height: 3),

                Text(
                  nearestHospital == null
                      ? "Finding hospital..."
                      : nearestHospital!.name,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),

                if (nearestHospital != null)
                  Text(
                    "${nearestDistance.toStringAsFixed(2)} km away",
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right_rounded, color: secondaryText),
        ],
      ),
    );
  }

  // =========================================================
  // TRACKING CARD
  // =========================================================

  Widget _buildTrackingCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),

      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_rounded, color: primaryBlue),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "Ambulance tracking",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: medicalTeal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  ambulanceStatus,
                  style: const TextStyle(
                    color: medicalTeal,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _trackingStat(
                  "ETA",
                  "$etaMinutes min",
                  Icons.schedule_rounded,
                ),
              ),

              Expanded(
                child: _trackingStat(
                  "Distance",
                  "${remainingDistance.toStringAsFixed(1)} km",
                  Icons.route_rounded,
                ),
              ),

              Expanded(
                child: _trackingStat(
                  "Speed",
                  "${ambulanceSpeed.toStringAsFixed(0)} km/h",
                  Icons.speed_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _callDriver() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: driverPhone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _messageDriver() async {
    final Uri messageUri = Uri(scheme: 'sms', path: driverPhone);

    if (await canLaunchUrl(messageUri)) {
      await launchUrl(messageUri);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open messaging app"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  // =========================================================
  // DRIVER CARD
  // =========================================================

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF2563EB),
                  size: 29,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: Color(0xFF0F766E),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Verified driver",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "4.9",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Vehicle information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_rounded,
                  color: Color(0xFF2563EB),
                  size: 21,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ambulance",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ambulanceNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  selectedAmbulanceType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Call + Message
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _callDriver,
                  icon: const Icon(Icons.call_rounded, size: 19),
                  label: const Text("Call"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(color: Color(0xFFBFDBFE)),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri messageUri = Uri(
                      scheme: 'sms',
                      path: driverPhone,
                    );

                    if (await canLaunchUrl(messageUri)) {
                      await launchUrl(messageUri);
                    } else {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Unable to open messaging app"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
                  label: const Text("Message"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // JOURNEY CARD
  // =========================================================

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Journey status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 16),

          _buildJourneyStep(
            step: 1,
            title: "Request confirmed",
            icon: Icons.check_rounded,
          ),

          _buildJourneyLine(),

          _buildJourneyStep(
            step: 2,
            title: "Ambulance on the way",
            icon: Icons.local_shipping_rounded,
          ),

          _buildJourneyLine(),

          _buildJourneyStep(
            step: 3,
            title: "Arrived at pickup",
            icon: Icons.location_on_rounded,
          ),

          _buildJourneyLine(),

          _buildJourneyStep(
            step: 4,
            title: "Patient picked up",
            icon: Icons.person_rounded,
          ),

          _buildJourneyLine(),

          _buildJourneyStep(
            step: 5,
            title: "Reached hospital",
            icon: Icons.local_hospital_rounded,
          ),
        ],
      ),
    );
  }

  void _showRequestConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Confirm ambulance request",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Please check the details before requesting.",
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 20),

                // Ambulance type
                _confirmationRow(
                  Icons.local_shipping_rounded,
                  "Ambulance type",
                  selectedAmbulanceType,
                  const Color(0xFF2563EB),
                ),

                const SizedBox(height: 12),

                // Pickup
                _confirmationRow(
                  Icons.location_on_rounded,
                  "Pickup",
                  "Current location",
                  const Color(0xFF2563EB),
                ),

                const SizedBox(height: 12),

                // Hospital
                _confirmationRow(
                  Icons.local_hospital_rounded,
                  "Nearest hospital",
                  nearestHospital?.name ?? "Finding hospital...",
                  const Color(0xFF0F766E),
                ),

                const SizedBox(height: 22),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      setState(() {
                        ambulanceRequested = true;
                        journeyStep = 1;
                        ambulanceStatus = "Finding ambulance...";
                      });

                      await _loadRoute();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "$selectedAmbulanceType ambulance requested",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Confirm Request",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Cancel
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _confirmationRow(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // =========================================================
  // REQUEST BUTTON
  // =========================================================

  Widget _buildRequestButton() {
    final bool completed = journeyStep == 5;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: ambulanceMoving
            ? null
            : completed
            ? null
            : () {
                _showRequestConfirmation();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: completed ? medicalTeal : primaryBlue,
          disabledBackgroundColor: completed
              ? medicalTeal
              : const Color(0xFFCBD5E1),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              completed
                  ? Icons.check_circle_rounded
                  : ambulanceMoving
                  ? Icons.local_shipping_rounded
                  : Icons.local_shipping_rounded,
            ),

            const SizedBox(width: 9),

            Text(
              completed
                  ? "Trip Completed"
                  : ambulanceMoving
                  ? "Ambulance on the way"
                  : ambulanceRequested
                  ? "Request confirmed"
                  : "Request Ambulance",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TRACKING STAT
  // =========================================================

  Widget _trackingStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 19, color: primaryBlue),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),

        const SizedBox(height: 2),

        Text(title, style: const TextStyle(fontSize: 10, color: secondaryText)),
      ],
    );
  }

  // =========================================================
  // SMALL ACTION BUTTON
  // =========================================================

  Widget _actionButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: const Color(0xFFEFF6FF),
      shape: const CircleBorder(),

      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,

        child: Padding(
          padding: const EdgeInsets.all(11),

          child: Icon(icon, color: primaryBlue, size: 20),
        ),
      ),
    );
  }

  // =========================================================
  // JOURNEY STEP
  // =========================================================

  Widget _buildJourneyStep({
    required int step,
    required String title,
    required IconData icon,
  }) {
    final bool completed = journeyStep >= step;

    final bool current = journeyStep == step;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: completed
                ? medicalTeal
                : current
                ? primaryBlue
                : const Color(0xFFF1F5F9),

            shape: BoxShape.circle,
          ),

          child: Icon(
            completed ? Icons.check_rounded : icon,

            color: completed || current
                ? Colors.white
                : const Color(0xFF94A3B8),

            size: 19,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Text(
            title,

            style: TextStyle(
              fontSize: 13,

              fontWeight: current || completed
                  ? FontWeight.w600
                  : FontWeight.w400,

              color: completed || current ? darkText : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // JOURNEY LINE
  // =========================================================

  Widget _buildJourneyLine() {
    return Container(
      margin: const EdgeInsets.only(left: 18),

      height: 18,
      width: 2,

      color: border,
    );
  }
}
