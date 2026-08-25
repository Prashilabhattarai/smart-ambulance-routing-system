import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // =========================================================
  // COLORS
  // =========================================================

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  // =========================================================
  // PAYMENT METHOD
  // =========================================================

  String selectedPayment = "Cash";

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "name": "Cash",
      "subtitle": "Pay directly to the ambulance team",
      "icon": Icons.payments_outlined,
    },
    {
      "name": "Digital Wallet",
      "subtitle": "eSewa, Khalti and other wallets",
      "icon": Icons.account_balance_wallet_outlined,
    },
    {
      "name": "Insurance",
      "subtitle": "Use eligible insurance coverage",
      "icon": Icons.health_and_safety_outlined,
    },
  ];

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
        centerTitle: false,

        title: const Text(
          "Payment",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // TRIP SUMMARY
              // =================================================
              _buildTripSummary(),

              const SizedBox(height: 22),

              // =================================================
              // PAYMENT METHODS
              // =================================================
              const Text(
                "Payment method",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 10),

              _buildPaymentMethods(),

              const SizedBox(height: 22),

              // =================================================
              // FARE BREAKDOWN
              // =================================================
              _buildFareBreakdown(),

              const SizedBox(height: 22),

              // =================================================
              // PAY BUTTON
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: _completePayment,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "Confirm Payment",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Payment details are securely handled.",
                  style: TextStyle(fontSize: 11, color: secondaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TRIP SUMMARY
  // =========================================================

  Widget _buildTripSummary() {
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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),

                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: primaryBlue,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Ambulance trip",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "BA 2 CHA 4567 • Basic",
                      style: TextStyle(fontSize: 12, color: secondaryText),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

                decoration: BoxDecoration(
                  color: medicalTeal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: medicalTeal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1, color: border),

          const SizedBox(height: 15),

          _locationRow(
            Icons.radio_button_checked_rounded,
            "Pickup",
            "Current location",
            primaryBlue,
          ),

          const SizedBox(height: 12),

          _locationRow(
            Icons.local_hospital_rounded,
            "Hospital",
            "Bir Hospital",
            medicalTeal,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOCATION ROW
  // =========================================================

  Widget _locationRow(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 19, color: color),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: secondaryText),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PAYMENT METHODS
  // =========================================================

  Widget _buildPaymentMethods() {
    return Column(
      children: paymentMethods.map((method) {
        final bool selected = selectedPayment == method["name"];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPayment = method["name"];
            });
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),

            margin: const EdgeInsets.only(bottom: 10),

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(15),

              border: Border.all(
                color: selected ? primaryBlue : border,
                width: selected ? 1.5 : 1,
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,

                  decoration: BoxDecoration(
                    color: selected
                        ? primaryBlue.withValues(alpha: 0.10)
                        : const Color(0xFFF8FAFC),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    method["icon"],
                    color: selected ? primaryBlue : secondaryText,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        method["name"],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        method["subtitle"],
                        style: const TextStyle(
                          fontSize: 11,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),

                  width: 22,
                  height: 22,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: selected ? primaryBlue : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),

                  child: selected
                      ? Container(
                          margin: const EdgeInsets.all(4),

                          decoration: const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================================================
  // FARE BREAKDOWN
  // =========================================================

  Widget _buildFareBreakdown() {
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
            "Fare breakdown",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),

          const SizedBox(height: 16),

          _fareRow("Base fare", "Rs. 800"),

          const SizedBox(height: 10),

          _fareRow("Distance charge", "Rs. 300"),

          const SizedBox(height: 10),

          _fareRow("Service fee", "Rs. 100"),

          const SizedBox(height: 14),

          const Divider(height: 1, color: border),

          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(
                child: Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),

              const Text(
                "Rs. 1,200",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FARE ROW
  // =========================================================

  Widget _fareRow(String title, String amount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: secondaryText),
          ),
        ),

        Text(
          amount,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // COMPLETE PAYMENT
  // =========================================================

  void _completePayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,

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
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Payment successful",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Rs. 1,200 paid via $selectedPayment",
                  style: const TextStyle(fontSize: 13, color: secondaryText),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Trip completed successfully."),
                          behavior: SnackBarBehavior.floating,
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

                    child: const Text(
                      "Done",
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
