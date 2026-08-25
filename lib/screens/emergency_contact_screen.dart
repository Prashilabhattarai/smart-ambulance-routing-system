import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkText = Color(0xFF0F172A);
  static const Color greyText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);

  final List<Map<String, String>> contacts = const [
    {
      "name": "Nepal Police",
      "number": "100",
      "description": "Police emergency service",
    },
    {
      "name": "Fire Brigade",
      "number": "101",
      "description": "Fire and rescue service",
    },
    {
      "name": "Ambulance",
      "number": "102",
      "description": "Emergency ambulance service",
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
          "Emergency Contacts",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

          children: [
            const Text(
              "Get emergency help",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Quickly contact the appropriate emergency service.",
              style: TextStyle(fontSize: 14, color: greyText),
            ),

            const SizedBox(height: 20),

            // Emergency information
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),

              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.support_agent_rounded,
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
                          "Emergency assistance",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Tap Call to contact a service.",
                          style: TextStyle(fontSize: 12, color: greyText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Emergency services",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),

            const SizedBox(height: 12),

            ...contacts.map((contact) => _contactCard(context, contact)),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, Map<String, String> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE2E8F0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: primaryBlue,
              size: 26,
            ),
          ),

          const SizedBox(width: 13),

          // Contact information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  contact["name"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  contact["description"]!,
                  style: const TextStyle(fontSize: 12, color: greyText),
                ),

                const SizedBox(height: 4),

                Text(
                  contact["number"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
              ],
            ),
          ),

          // Call button
          SizedBox(
            height: 42,

            child: ElevatedButton.icon(
              onPressed: () async {
                final phoneNumber = contact["number"]!;

                final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Unable to call ${contact["name"]}"),
                    ),
                  );
                }
              },

              icon: const Icon(Icons.call_rounded, size: 17),

              label: const Text("Call"),

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,

                padding: const EdgeInsets.symmetric(horizontal: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
