import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/notifications/notifications.dart';
import 'package:everli_client_v2/common/widgets/dashboard.dart';
import 'package:everli_client_v2/features/auth/presentation/screens/on_boarding_screen.dart';
import 'package:flutter/material.dart';
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

    // Load user
    context.read<AppUserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserCubitState>(
      builder: (context, state) {
        if (state is AppUserAuthenticated) {
          return const Dashboard();
        } else {
          return const OnBoardingScreen();
        }
      },
    );
  }
}
