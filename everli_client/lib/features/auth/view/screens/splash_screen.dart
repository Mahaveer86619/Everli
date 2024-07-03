import 'dart:async';

import 'package:everli_client/features/auth/view/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3, milliseconds: 725), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildLoading(),
      ),
    );
  }

  _buildLoading() {
    return Text(
      'Everli',
      style: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground,
      )
    ).animate().fadeIn(duration: Durations.long1).fadeOut(
          duration: Durations.long1,
          delay: const Duration(seconds: 3),
        );
  }
}
