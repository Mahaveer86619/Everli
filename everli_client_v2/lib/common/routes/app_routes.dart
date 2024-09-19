import 'package:everli_client_v2/common/auth_gate/auth_gate.dart';
import 'package:everli_client_v2/features/auth/presentation/screens/forgot_pass_screen.dart';
import 'package:everli_client_v2/features/auth/presentation/screens/on_boarding_screen.dart';
import 'package:everli_client_v2/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:everli_client_v2/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:everli_client_v2/common/widgets/splash_screen.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  '/': (context) => const SplashScreen(),

  // Auth Routes
  '/auth-gate': (context) => const AuthGate(),
  '/on-boarding': (context) => const OnBoardingScreen(),
  '/sign-in': (context) => const SignInScreen(),
  '/sign-up': (context) => const SignUpScreen(),
  '/forgot-pass': (context) => const ForgotPasswordScreen(),

  // Home Routes
};
