import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color medicalTeal = Color(0xFF0F766E);
  static const Color darkText = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 88,
              height: 88,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryBlue, medicalTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(26),

                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),

            const SizedBox(height: 22),

            // Brand
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Smart ",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: "Ambulance",
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "FAST  •  SAFE  •  RELIABLE",
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 45),

            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
