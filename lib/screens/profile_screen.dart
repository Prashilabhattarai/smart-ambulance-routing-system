import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  final List<Map<String, String>> emergencyContacts = [
    {"name": "Mother", "phone": "+977 9800000000", "relation": "Family"},
    {"name": "Father", "phone": "+977 9811111111", "relation": "Family"},
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
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            _buildProfileHeader(),

            const SizedBox(height: 20),

            _buildSectionTitle("Emergency contacts"),

            const SizedBox(height: 10),

            _buildEmergencyContacts(),

            const SizedBox(height: 22),

            _buildSectionTitle("Account"),

            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.history_rounded,
              title: "Trip history",
              subtitle: "View your previous ambulance trips",
              onTap: () {
                Navigator.pushNamed(context, '/ride-history');
              },
            ),

            _buildMenuCard(
              icon: Icons.location_on_outlined,
              title: "Saved locations",
              subtitle: "Manage your saved pickup addresses",
              onTap: () {},
            ),

            _buildMenuCard(
              icon: Icons.payment_rounded,
              title: "Payment methods",
              subtitle: "Manage payment preferences",
              onTap: () {},
            ),

            const SizedBox(height: 22),

            _buildSectionTitle("Preferences"),

            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              subtitle: "Manage emergency and trip alerts",
              onTap: () {},
            ),

            _buildMenuCard(
              icon: Icons.accessibility_new_rounded,
              title: "Accessibility",
              subtitle: "Text size and accessibility options",
              onTap: () {},
            ),

            const SizedBox(height: 22),

            _buildSectionTitle("Support"),

            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.help_outline_rounded,
              title: "Help & support",
              subtitle: "Get assistance with Smart Ambulance",
              onTap: () {},
            ),

            _buildMenuCard(
              icon: Icons.info_outline_rounded,
              title: "About Smart Ambulance",
              subtitle: "App information and version",
              onTap: () {
                _showAboutDialog();
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout_rounded, size: 19),
                label: const Text("Log out"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Text(
                "Smart Ambulance • v1.0.0",
                style: TextStyle(fontSize: 11, color: secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE HEADER
  // =========================================================

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),

      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_rounded,
              size: 34,
              color: primaryBlue,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Prashila Bhattarai",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "+977 98XXXXXXXX",
                  style: TextStyle(fontSize: 12, color: secondaryText),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: medicalTeal,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    const Text(
                      "Verified account",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: medicalTeal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, color: primaryBlue),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: darkText,
      ),
    );
  }

  // =========================================================
  // EMERGENCY CONTACTS
  // =========================================================

  Widget _buildEmergencyContacts() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),

      child: Column(
        children: [
          ...emergencyContacts.asMap().entries.map((entry) {
            final index = entry.key;
            final contact = entry.value;

            return Column(
              children: [
                _buildContactTile(contact),

                if (index != emergencyContacts.length - 1)
                  const Divider(
                    height: 1,
                    indent: 70,
                    endIndent: 16,
                    color: border,
                  ),
              ],
            );
          }),

          const Divider(height: 1, color: border),

          InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: _addEmergencyContact,

            child: const Padding(
              padding: EdgeInsets.all(15),

              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: primaryBlue,
                    size: 23,
                  ),

                  SizedBox(width: 12),

                  Text(
                    "Add emergency contact",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CONTACT TILE
  // =========================================================

  Widget _buildContactTile(Map<String, String> contact) {
    return Padding(
      padding: const EdgeInsets.all(14),

      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.person_outline_rounded,
              color: medicalTeal,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact["name"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "${contact["relation"]} • ${contact["phone"]}",
                  style: const TextStyle(fontSize: 11, color: secondaryText),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              _editContact(contact);
            },
            icon: const Icon(Icons.more_vert_rounded, color: secondaryText),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MENU CARD
  // =========================================================

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),

      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),

        leading: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(icon, color: primaryBlue, size: 21),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: secondaryText),
        ),

        trailing: const Icon(Icons.chevron_right_rounded, color: secondaryText),
      ),
    );
  }

  // =========================================================
  // EDIT PROFILE
  // =========================================================

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile editing will be available soon."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // ADD CONTACT
  // =========================================================

  void _addEmergencyContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (context) {
        return _contactForm(
          title: "Add emergency contact",
          nameController: nameController,
          phoneController: phoneController,
          onSave: () {
            if (nameController.text.trim().isEmpty ||
                phoneController.text.trim().isEmpty) {
              return;
            }

            setState(() {
              emergencyContacts.add({
                "name": nameController.text.trim(),
                "phone": phoneController.text.trim(),
                "relation": "Emergency contact",
              });
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  // =========================================================
  // EDIT CONTACT
  // =========================================================

  void _editContact(Map<String, String> contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: primaryBlue),
                  title: const Text("Edit contact"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                  ),
                  title: const Text(
                    "Remove contact",
                    style: TextStyle(color: Color(0xFFDC2626)),
                  ),
                  onTap: () {
                    setState(() {
                      emergencyContacts.remove(contact);
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // CONTACT FORM
  // =========================================================

  Widget _contactForm({
    required String title,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required VoidCallback onSave,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        15,
        20,
        MediaQuery.of(context).viewInsets.bottom + 25,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),

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

          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name",
              prefixIcon: const Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone number",
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: onSave,

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),

              child: const Text(
                "Save contact",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ABOUT
  // =========================================================

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Smart Ambulance",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(
        Icons.local_shipping_rounded,
        color: primaryBlue,
        size: 32,
      ),
      children: const [
        Text(
          "A smart ambulance booking and emergency response platform designed to connect patients with nearby ambulance services.",
        ),
      ],
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Log out?",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),

          content: const Text(
            "Are you sure you want to log out of Smart Ambulance?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully.")),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),

              child: const Text("Log out"),
            ),
          ],
        );
      },
    );
  }
}
