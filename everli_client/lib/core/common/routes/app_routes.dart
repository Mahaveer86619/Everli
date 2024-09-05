import 'package:everli_client/core/common/auth_gate/auth_gate.dart';
import 'package:everli_client/features/app/presentation/home/views/screens/create_event_screen.dart';
import 'package:everli_client/features/app/presentation/home/views/screens/home_screen.dart';
import 'package:everli_client/features/app/presentation/home/views/screens/join_events_screen.dart';
import 'package:everli_client/features/auth/view/screens/complete_profile_screen.dart';
import 'package:everli_client/features/auth/view/screens/onboarding_screen.dart';
import 'package:everli_client/features/auth/view/screens/phone_auth_screen.dart';
import 'package:everli_client/features/auth/view/screens/sign_in_screen.dart';
import 'package:everli_client/features/auth/view/screens/sign_up_screen.dart';
import 'package:everli_client/features/auth/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  '/': (context) => const SplashScreen(),

  // Auth Routes
  '/auth-gate': (context) => const AuthGate(),
  '/on-boarding': (context) => const OnBoardingScreen(),
  '/sign-in': (context) => const SignInScreen(),
  '/sign-up': (context) => const SignUpScreen(),
  // 'forgot_password': (context) => const ForgotPasswordScreen(),
  '/phone-verification': (context) => const PhoneAuthScreen(),
  '/complete-profile': (context) => const CompleteProfileScreen(),

  // Dashboard Routes
  // Home Routes
  '/home': (context) => const HomeScreen(),
  '/home/join-event': (context) => const JoinEventScreen(),
  '/home/create-event': (context) => const CreateEventScreen(),
  // Tasks Routes
  // Chat Routes
};
