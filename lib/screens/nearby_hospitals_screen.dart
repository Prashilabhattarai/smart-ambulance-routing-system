import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyHospitalsScreen extends StatelessWidget {
  const NearbyHospitalsScreen({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  final List<Map<String, dynamic>> hospitals = const [
    {
      "name": "Bir Hospital",
      "location": "Kanti Path, Kathmandu",
      "distance": "1.2 km",
      "status": "Open 24/7",
      "phone": "01-4221119",
      "type": "Government",
    },
    {
      "name": "Teaching Hospital",
      "location": "Maharajgunj, Kathmandu",
      "distance": "2.8 km",
      "status": "Open 24/7",
      "phone": "01-4412303",
      "type": "Teaching Hospital",
    },
    {
      "name": "Patan Hospital",
      "location": "Lagankhel, Lalitpur",
      "distance": "4.5 km",
      "status": "Open 24/7",
      "phone": "01-5522278",
      "type": "General Hospital",
    },
    {
      "name": "Civil Service Hospital",
      "location": "Min Bhawan, Kathmandu",
      "distance": "3.1 km",
      "status": "Open 24/7",
      "phone": "01-4793000",
      "type": "General Hospital",
    },
    {
      "name": "Grande International Hospital",
      "location": "Dhapasi, Kathmandu",
      "distance": "5.6 km",
      "status": "Open 24/7",
      "phone": "01-5159266",
      "type": "Private Hospital",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 0,
        surfaceTintColor: Colors.white,

        title: const Text(
          "Nearby Hospitals",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              _showInfo(context);
            },
            icon: const Icon(Icons.info_outline_rounded, color: secondaryText),
          ),

          const SizedBox(width: 6),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: SafeArea(
        child: Column(
          children: [
            // LOCATION HEADER
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),

              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.my_location_rounded,
                      color: primaryBlue,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 11),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your location",
                          style: TextStyle(fontSize: 10, color: secondaryText),
                        ),

                        SizedBox(height: 3),

                        Text(
                          "Kathmandu, Nepal",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Using your current location"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FILTER ROW
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),

              child: Row(
                children: [
                  const Text(
                    "Hospitals near you",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),

                    child: const Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 16,
                          color: secondaryText,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Nearest",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // HOSPITAL LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 25),

                itemCount: hospitals.length,

                itemBuilder: (context, index) {
                  final hospital = hospitals[index];

                  return _buildHospitalCard(context, hospital, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HOSPITAL CARD
  // =========================================================

  Widget _buildHospitalCard(
    BuildContext context,
    Map<String, dynamic> hospital,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // -------------------------------------------------
          // TOP
          // -------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: medicalTeal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: medicalTeal,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      hospital["name"],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: secondaryText,
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            hospital["location"],
                            style: const TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // DISTANCE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  hospital["distance"],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // -------------------------------------------------
          // INFORMATION
          // -------------------------------------------------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(7),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: medicalTeal,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      hospital["status"],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: medicalTeal,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(7),
                ),

                child: Text(
                  hospital["type"],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: secondaryText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // -------------------------------------------------
          // ACTIONS
          // -------------------------------------------------
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _callHospital(context, hospital["phone"]);
                  },

                  icon: const Icon(Icons.call_rounded, size: 17),

                  label: const Text("Call"),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,

                    side: const BorderSide(color: Color(0xFFBFDBFE)),

                    minimumSize: const Size(0, 44),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _openDirections(context, hospital["name"]);
                  },

                  icon: const Icon(Icons.directions_rounded, size: 17),

                  label: const Text("Directions"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    minimumSize: const Size(0, 44),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
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
  // CALL HOSPITAL
  // =========================================================

  Future<void> _callHospital(BuildContext context, String phone) async {
    final Uri phoneUri = Uri(scheme: "tel", path: phone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open phone application"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // =========================================================
  // DIRECTIONS
  // =========================================================

  void _openDirections(BuildContext context, String hospitalName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Directions to $hospitalName"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // INFO
  // =========================================================

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,

                    decoration: BoxDecoration(
                      color: border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Nearby hospitals",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Hospitals are displayed based on your current location. Availability information may change and should be confirmed with the hospital.",
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      "Got it",
                      style: TextStyle(fontWeight: FontWeight.w700),
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
}
