import 'package:flutter/material.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  final List<Map<String, dynamic>> trips = const [
    {
      "date": "24 Aug 2026",
      "time": "10:35 AM",
      "hospital": "Bir Hospital",
      "type": "Basic",
      "vehicle": "BA 2 CHA 4567",
      "fare": "Rs. 1,200",
      "status": "Completed",
    },
    {
      "date": "18 Aug 2026",
      "time": "04:20 PM",
      "hospital": "Teaching Hospital",
      "type": "ICU",
      "vehicle": "BA 3 CHA 7821",
      "fare": "Rs. 2,500",
      "status": "Completed",
    },
    {
      "date": "07 Aug 2026",
      "time": "09:15 AM",
      "hospital": "Patan Hospital",
      "type": "Basic",
      "vehicle": "BA 1 CHA 3489",
      "fare": "Rs. 1,050",
      "status": "Completed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 0,

        title: const Text(
          "Trip History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ),

      body: SafeArea(
        child: trips.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(context, trips[index]);
                },
              ),
      ),
    );
  }

  // =========================================================
  // TRIP CARD
  // =========================================================

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(17),

        onTap: () {
          _showTripDetails(context, trip);
        },

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            children: [
              // -------------------------------------------------
              // TOP ROW
              // -------------------------------------------------
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

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip["hospital"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${trip["date"]} • ${trip["time"]}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),

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

              const SizedBox(height: 14),

              const Divider(height: 1, color: border),

              const SizedBox(height: 13),

              // -------------------------------------------------
              // DETAILS
              // -------------------------------------------------
              Row(
                children: [
                  Expanded(child: _detailItem("Ambulance", trip["type"])),

                  Expanded(child: _detailItem("Vehicle", trip["vehicle"])),

                  _detailItem("Fare", trip["fare"], alignRight: true),
                ],
              ),

              const SizedBox(height: 13),

              // -------------------------------------------------
              // VIEW DETAILS
              // -------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  const Text(
                    "View details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(width: 3),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: primaryBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DETAIL ITEM
  // =========================================================

  Widget _detailItem(String title, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,

      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: secondaryText)),

        const SizedBox(height: 3),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history_rounded,
                color: primaryBlue,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No trips yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Your completed ambulance trips will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: secondaryText),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TRIP DETAILS
  // =========================================================

  void _showTripDetails(BuildContext context, Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),

          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,

                    decoration: BoxDecoration(
                      color: border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Trip details",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 18),

                _bottomDetail(
                  "Date & time",
                  "${trip["date"]} • ${trip["time"]}",
                ),

                _bottomDetail("Hospital", trip["hospital"]),

                _bottomDetail("Ambulance type", trip["type"]),

                _bottomDetail("Vehicle", trip["vehicle"]),

                _bottomDetail("Payment", "Cash"),

                const Divider(height: 22, color: border),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Total fare",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                    ),

                    Text(
                      trip["fare"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryBlue,
                      side: const BorderSide(color: Color(0xFFBFDBFE)),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),

                    child: const Text(
                      "Close",
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

  // =========================================================
  // BOTTOM DETAIL
  // =========================================================

  Widget _bottomDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: secondaryText),
            ),
          ),

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
    );
  }
}
