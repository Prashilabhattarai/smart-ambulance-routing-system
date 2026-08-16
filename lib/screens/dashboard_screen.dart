import 'package:flutter/material.dart';
import 'request_ambulance_screen.dart';
import '../widgets/map_preview.dart';
import 'package:latlong2/latlong.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,

        title: const Text(
          "Smart Ambulance",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),

        centerTitle: false,

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),

          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: primaryBlue,
              child: Text(
                "P",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Greeting
            const Text(
              "Good day, Prashila",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "How can we help you?",
              style: TextStyle(fontSize: 16, color: textGrey),
            ),

            const SizedBox(height: 22),

            // Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),

              child: const Row(
                children: [
                  Icon(Icons.location_on_rounded, color: primaryBlue, size: 23),

                  SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current location",
                          style: TextStyle(fontSize: 12, color: textGrey),
                        ),

                        SizedBox(height: 2),

                        Text(
                          "Your current position",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.chevron_right_rounded, color: textGrey),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Map preview
            SizedBox(
              height: 210,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: const MapPreview(location: LatLng(27.7172, 85.3240)),
              ),
            ),

            const SizedBox(height: 20),

            // Main action
            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestAmbulanceScreen(),
                    ),
                  );
                },

                icon: const Icon(Icons.local_shipping_rounded),

                label: const Text(
                  "Request Ambulance",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    icon: Icons.local_hospital_rounded,
                    title: "Hospitals",
                    color: const Color(0xFF0F766E),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Nearby Hospitals clicked"),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _quickAction(
                    icon: Icons.location_on_rounded,
                    title: "Location",
                    color: primaryBlue,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Current Location clicked"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    icon: Icons.phone_rounded,
                    title: "Emergency",
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Emergency Contact clicked"),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _quickAction(
                    icon: Icons.history_rounded,
                    title: "My Requests",
                    color: const Color(0xFF64748B),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Request History clicked"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Emergency notice
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),

              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFFD97706)),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "For immediate emergencies, request an ambulance or contact emergency services.",
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(14),

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),

        child: Column(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: color.withValues(alpha: 0.10),

              child: Icon(icon, color: color, size: 24),
            ),

            const SizedBox(height: 9),

            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
