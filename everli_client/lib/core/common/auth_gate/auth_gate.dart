import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/features/auth/view/screens/onboarding_screen.dart';
import 'package:everli_client/features/app/presentation/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:everli_client/core/common/notifications/notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserAuthenticated) {
          return const MainWrapper();
        } else {
          return const OnBoardingScreen();
        }
      },
    );
  }
}
