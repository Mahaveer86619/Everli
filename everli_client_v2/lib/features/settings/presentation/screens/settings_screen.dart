import 'package:everli_client_v2/common/widgets/drawer.dart';
import 'package:everli_client_v2/features/auth/domain/entities/app_user_entity.dart';
import 'package:everli_client_v2/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _changeScreen(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool isReplacement = false,
  }) {
    if (isReplacement) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(GetUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            _showMessage(state.message);
          }
        },
        builder: (context, state) {
          if (state is HomeUserInfoFetched) {
            return Scaffold(
              appBar: _buildAppBar(state.user),
              drawer: MyDrawer(appUser: state.user),
              body: _buildBody(),
            );
          }
          if (state is HomeError) {
            return Scaffold(
              appBar: _buildAppBar(null),
              drawer: const MyDrawer(appUser: null),
              body: _buildErrorBody(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  _buildAppBar(AppUserEntity? user) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }

  _buildErrorBody(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
      ],
    );
  }

  _buildBody() {
    return Center(
      child: Text(
        'Settings Screen',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );
  }
}
