import 'package:flutter/material.dart';

class TripSummaryScreen extends StatelessWidget {
  const TripSummaryScreen({super.key});

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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: darkText,
        title: const Text(
          "Trip Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

          child: Column(
            children: [
              // SUCCESS HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: medicalTeal.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: medicalTeal,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Trip Completed",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Your ambulance trip has been completed successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: secondaryText),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // TRIP DETAILS
              _sectionCard(
                title: "Trip details",
                child: Column(
                  children: [
                    _detailRow(
                      Icons.local_shipping_rounded,
                      "Ambulance type",
                      "Basic",
                    ),

                    _divider(),

                    _detailRow(
                      Icons.confirmation_number_rounded,
                      "Ambulance number",
                      "BA 2 CHA 4567",
                    ),

                    _divider(),

                    _detailRow(Icons.person_rounded, "Driver", "Ram Sharma"),

                    _divider(),

                    _detailRow(
                      Icons.access_time_rounded,
                      "Trip duration",
                      "18 minutes",
                    ),

                    _divider(),

                    _detailRow(Icons.route_rounded, "Distance", "6.4 km"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ROUTE
              _sectionCard(
                title: "Journey",
                child: Column(
                  children: [
                    _locationRow(
                      icon: Icons.radio_button_checked,
                      iconColor: primaryBlue,
                      title: "Pickup",
                      value: "Current location",
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(height: 28, width: 2, color: border),
                    ),

                    _locationRow(
                      icon: Icons.local_hospital_rounded,
                      iconColor: medicalTeal,
                      title: "Hospital",
                      value: "Bir Hospital",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // PAYMENT
              _sectionCard(
                title: "Payment",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: primaryBlue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment method",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryText,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Cash",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: darkText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Text(
                          "Paid",
                          style: TextStyle(
                            color: medicalTeal,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "Total fare",
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryText,
                            ),
                          ),

                          Spacer(),

                          Text(
                            "Rs. 1,250",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // RECEIPT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Receipt download coming soon"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text(
                    "Download Receipt",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: const BorderSide(color: Color(0xFFBFDBFE)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // DONE
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION CARD
  // =========================================================

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  // =========================================================
  // DETAIL ROW
  // =========================================================

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: primaryBlue),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: secondaryText),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // LOCATION ROW
  // =========================================================

  Widget _locationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 21, color: iconColor),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: secondaryText),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: border),
    );
  }
}
