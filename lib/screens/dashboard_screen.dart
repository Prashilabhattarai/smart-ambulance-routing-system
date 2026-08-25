import 'package:flutter/material.dart';

import 'request_ambulance_screen.dart';
import 'nearby_hospitals_screen.dart';
import 'emergency_contact_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ---------------- COLORS ----------------

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        titleSpacing: 20,

        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              "SmartAmbulance",
              style: TextStyle(
                color: darkText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: darkText,
              size: 28,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // GREETING
              // =================================================
              const Text(
                "Good morning",
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),

              const SizedBox(height: 4),

              const Text(
                "How can we help?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // LOCATION
              // =================================================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: border),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,

                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.location_on_rounded,
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
                            "Current location",
                            style: TextStyle(
                              fontSize: 10,
                              color: secondaryText,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            "Kathmandu, Nepal",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: darkText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.my_location_rounded,
                      color: primaryBlue,
                      size: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // MAIN REQUEST CARD
              // =================================================
              _buildRequestCard(context),

              const SizedBox(height: 26),

              // =================================================
              // SERVICES
              // =================================================
              const Text(
                "Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.local_hospital_rounded,
                      title: "Hospitals",
                      subtitle: "Nearby hospitals",
                      color: medicalTeal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NearbyHospitalsScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.emergency_rounded,
                      title: "Emergency",
                      subtitle: "Quick contacts",
                      color: const Color(0xFF7C3AED),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmergencyContactScreen(),
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
                    child: _serviceCard(
                      context,
                      icon: Icons.history_rounded,
                      title: "Trip history",
                      subtitle: "View past trips",
                      color: const Color(0xFF475569),
                      onTap: () {
                        _showComingSoon(context, "Trip history");
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: "Profile",
                      subtitle: "Account settings",
                      color: primaryBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // =================================================
              // EMERGENCY CONTACT
              // =================================================
              _buildEmergencyCard(context),

              const SizedBox(height: 24),

              // =================================================
              // TRUST SECTION
              // =================================================
              const Text(
                "Why SmartAmbulance?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _trustItem(Icons.speed_rounded, "Fast response"),
                  ),

                  Expanded(
                    child: _trustItem(
                      Icons.verified_user_outlined,
                      "Verified drivers",
                    ),
                  ),

                  Expanded(
                    child: _trustItem(
                      Icons.location_on_outlined,
                      "Live tracking",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // =====================================================
      // BOTTOM NAVIGATION
      // =====================================================
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // =========================================================
  // REQUEST CARD
  // =========================================================

  Widget _buildRequestCard(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),

                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: primaryBlue,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Need an ambulance?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      "Request nearby medical transport",
                      style: TextStyle(fontSize: 12, color: secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RequestAmbulanceScreen(),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_rounded, size: 21),

                  SizedBox(width: 9),

                  Text(
                    "Request Ambulance",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Available 24/7",
              style: TextStyle(
                fontSize: 11,
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SERVICE CARD
  // =========================================================

  Widget _serviceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,

      borderRadius: BorderRadius.circular(17),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(17),

        child: Container(
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, color: color, size: 22),
              ),

              const SizedBox(height: 13),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: secondaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EMERGENCY CARD
  // =========================================================

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFCCFBF1)),
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: medicalTeal.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: medicalTeal,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency contacts",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Quick access to emergency services",
                  style: TextStyle(fontSize: 11, color: secondaryText),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmergencyContactScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: medicalTeal,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TRUST ITEM
  // =========================================================

  Widget _trustItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),

          child: Icon(icon, size: 20, color: primaryBlue),
        ),

        const SizedBox(height: 8),

        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: secondaryText,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(top: BorderSide(color: border, width: 1)),
      ),

      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _bottomItem(Icons.home_rounded, "Home", true, () {}),

              _bottomItem(Icons.location_on_outlined, "Hospitals", false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NearbyHospitalsScreen(),
                  ),
                );
              }),

              _bottomItem(Icons.receipt_long_outlined, "Trips", false, () {
                _showComingSoon(context, "Trip history");
              }),

              _bottomItem(Icons.person_outline_rounded, "Profile", false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 22, color: selected ? primaryBlue : secondaryText),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? primaryBlue : secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COMING SOON
  // =========================================================

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature will be available soon."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
