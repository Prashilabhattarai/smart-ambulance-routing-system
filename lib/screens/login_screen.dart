import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool isLoading = false;

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);
  static const Color greyText = Color(0xFF64748B);
  static const Color background = Color(0xFFF8FAFC);

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // =====================================================
  // SEND OTP
  // =====================================================

  void _sendOtp() {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _showMessage("Please enter a valid 10-digit phone number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulated OTP request
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        otpSent = true;
      });

      _showMessage("OTP sent to +977 $phone");
    });
  }

  // =====================================================
  // VERIFY OTP
  // =====================================================

  void _verifyOtp() {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _showMessage("Please enter the 6-digit OTP");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulated OTP verification
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  // =====================================================
  // MESSAGE
  // =====================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              const SizedBox(height: 55),

              // ------------------------------------------------
              // LOGO
              // ------------------------------------------------
              Container(
                width: 82,
                height: 82,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryBlue, medicalTeal],

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // BRAND NAME
              // ------------------------------------------------
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Smart ",
                      style: TextStyle(
                        color: darkText,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    TextSpan(
                      text: "Ambulance",
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "FAST  •  SAFE  •  RELIABLE",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  color: greyText,
                ),
              ),

              const SizedBox(height: 50),

              // ------------------------------------------------
              // TITLE
              // ------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  otpSent ? "Verify your number" : "Welcome back!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  otpSent
                      ? "Enter the verification code sent to your phone."
                      : "Sign in to request and track your ambulance.",
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: greyText,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // PHONE / OTP CARD
              // ------------------------------------------------
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: const Color(0xFFE2E8F0)),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      otpSent ? "Verification code" : "Mobile number",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 9),

                    if (!otpSent) _phoneField() else _otpField(),

                    const SizedBox(height: 18),

                    // ------------------------------------------------
                    // MAIN BUTTON
                    // ------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : otpSent
                            ? _verifyOtp
                            : _sendOtp,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,

                          disabledBackgroundColor: primaryBlue.withValues(
                            alpha: 0.6,
                          ),

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: isLoading
                            ? const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Text(
                                    otpSent ? "Verify & Continue" : "Send OTP",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),
              const SizedBox(height: 22),

              // ------------------------------------------------
              // GOOGLE LOGIN
              // ------------------------------------------------
              if (!otpSent) ...[
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE2E8F0))),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: greyText,
                        ),
                      ),
                    ),

                    const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton(
                    onPressed: () {
                      // Prototype Google login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    },

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: darkText,

                      side: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      elevation: 0,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        // Google-style G
                        Container(
                          width: 22,
                          height: 22,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),

                          child: const Center(
                            child: Text(
                              "G",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // ------------------------------------------------
              // SECURITY MESSAGE
              // ------------------------------------------------

              // ------------------------------------------------
              // SECURITY MESSAGE
              // ------------------------------------------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: const Color(0xFFCCFBF1)),
                ),

                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 20,
                      color: medicalTeal,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Your phone number helps us securely identify your account.",
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------
              // TERMS
              // ------------------------------------------------
              const Text(
                "By continuing, you agree to our Terms of Service\n"
                "and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, height: 1.5, color: greyText),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PHONE FIELD
  // =====================================================

  Widget _phoneField() {
    return TextField(
      controller: phoneController,

      keyboardType: TextInputType.phone,

      maxLength: 10,

      decoration: InputDecoration(
        counterText: "",

        prefixIcon: const Icon(Icons.phone_outlined, color: primaryBlue),

        prefixText: "+977  ",

        prefixStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: darkText,
        ),

        hintText: "98XXXXXXXX",

        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),

        filled: true,

        fillColor: const Color(0xFFF8FAFC),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // =====================================================
  // OTP FIELD
  // =====================================================

  Widget _otpField() {
    return TextField(
      controller: otpController,

      keyboardType: TextInputType.number,

      maxLength: 6,

      textAlign: TextAlign.center,

      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 8,
        color: darkText,
      ),

      decoration: InputDecoration(
        counterText: "",

        prefixIcon: const Icon(Icons.lock_outline_rounded, color: primaryBlue),

        hintText: "------",

        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), letterSpacing: 8),

        filled: true,

        fillColor: const Color(0xFFF8FAFC),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
    );
  }
}
