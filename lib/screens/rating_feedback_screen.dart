import 'package:flutter/material.dart';

class RatingFeedbackScreen extends StatefulWidget {
  const RatingFeedbackScreen({super.key});

  @override
  State<RatingFeedbackScreen> createState() => _RatingFeedbackScreenState();
}

class _RatingFeedbackScreenState extends State<RatingFeedbackScreen> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  int selectedRating = 0;

  final TextEditingController feedbackController = TextEditingController();

  final List<String> ratingLabels = [
    "",
    "Very poor",
    "Poor",
    "Okay",
    "Good",
    "Excellent",
  ];

  final List<String> quickFeedback = [
    "Professional driver",
    "Quick response",
    "Clean ambulance",
    "Friendly staff",
    "Smooth trip",
  ];

  final Set<String> selectedFeedback = {};

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 0,

        title: const Text(
          "Trip Feedback",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // =================================================
              // SUCCESS ICON
              // =================================================
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

              const SizedBox(height: 16),

              const Text(
                "How was your trip?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Your feedback helps us improve emergency care.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),

              const SizedBox(height: 24),

              // =================================================
              // DRIVER CARD
              // =================================================
              _buildDriverCard(),

              const SizedBox(height: 22),

              // =================================================
              // RATING
              // =================================================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rate your experience",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _buildRating(),

              const SizedBox(height: 10),

              Text(
                selectedRating == 0
                    ? "Tap a star to rate"
                    : ratingLabels[selectedRating],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selectedRating == 0 ? secondaryText : primaryBlue,
                ),
              ),

              const SizedBox(height: 24),

              // =================================================
              // QUICK FEEDBACK
              // =================================================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What went well?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _buildQuickFeedback(),

              const SizedBox(height: 22),

              // =================================================
              // COMMENT
              // =================================================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional feedback",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: feedbackController,
                maxLines: 4,

                decoration: InputDecoration(
                  hintText: "Tell us about your experience...",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.all(14),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: border),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: border),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // =================================================
              // SUBMIT
              // =================================================
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  onPressed: selectedRating == 0 ? null : _submitFeedback,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "Skip for now",
                  style: TextStyle(
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
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
  // DRIVER CARD
  // =========================================================

  Widget _buildDriverCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_rounded,
              color: primaryBlue,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Ram Sharma",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "BA 2 CHA 4567 • Basic Ambulance",
                  style: TextStyle(fontSize: 11, color: secondaryText),
                ),
              ],
            ),
          ),

          const Icon(Icons.verified_rounded, color: medicalTeal, size: 20),
        ],
      ),
    );
  }

  // =========================================================
  // STAR RATING
  // =========================================================

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(5, (index) {
        final int star = index + 1;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRating = star;
            });
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),

            child: Icon(
              star <= selectedRating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,

              size: 42,

              color: star <= selectedRating
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFCBD5E1),
            ),
          ),
        );
      }),
    );
  }

  // =========================================================
  // QUICK FEEDBACK
  // =========================================================

  Widget _buildQuickFeedback() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children: quickFeedback.map((feedback) {
        final bool selected = selectedFeedback.contains(feedback);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                selectedFeedback.remove(feedback);
              } else {
                selectedFeedback.add(feedback);
              }
            });
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),

            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),

            decoration: BoxDecoration(
              color: selected
                  ? primaryBlue.withValues(alpha: 0.10)
                  : Colors.white,

              borderRadius: BorderRadius.circular(20),

              border: Border.all(color: selected ? primaryBlue : border),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                if (selected) ...[
                  const Icon(Icons.check_rounded, size: 15, color: primaryBlue),

                  const SizedBox(width: 4),
                ],

                Text(
                  feedback,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? primaryBlue : secondaryText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  void _submitFeedback() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 60,
                height: 60,

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

              const SizedBox(height: 16),

              const Text(
                "Thank you!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Your feedback has been submitted successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 46,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                    "Done",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
