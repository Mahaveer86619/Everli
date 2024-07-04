import 'dart:convert';

import 'package:everli_client/core/common/auth_gate/auth_gate.dart';
import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _test();
  }

  Future<void> _test() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(prefUserKey);
    if (userJson != null) {
      debugPrint(
          'saved user: ${AppUser.fromJson(jsonDecode(userJson)).toString()}');
    } else {
      debugPrint('no saved user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                final userCubit = context.read<AppUserCubit>();
                userCubit.signOut();
                _changeScreen(const AuthGate());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Home Screen',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
      ),
    );
  }
}
