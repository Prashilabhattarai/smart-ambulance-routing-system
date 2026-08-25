import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/ride_history_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/rating_feedback_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SmartAmbulanceApp());
}

class SmartAmbulanceApp extends StatelessWidget {
  const SmartAmbulanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Ambulance',
      home: const SplashScreen(),
      routes: {
        '/ride-history': (context) => const RideHistoryScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/rating-feedback': (context) => const RatingFeedbackScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
