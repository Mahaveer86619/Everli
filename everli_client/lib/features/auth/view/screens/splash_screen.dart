import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_layout/responsive.dart';

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
      Navigator.pushReplacementNamed(context, '/auth-gate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ResponsiveLayout(
          smallScreen: _buildLoading(48.0),
          mediumScreen: _buildLoading(56.0),
          largeScreen: _buildLoading(64.0),
        )
      ),
    );
  }

  _buildLoading(double textSize) {
    return Text('Everli',
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            )).animate().fadeIn(duration: Durations.long1).fadeOut(
          duration: Durations.long1,
          delay: const Duration(seconds: 3),
        );
  }
}
