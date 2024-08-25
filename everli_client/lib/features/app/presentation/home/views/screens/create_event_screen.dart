import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/widgets/error_screen.dart';
import 'package:everli_client/features/app/presentation/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  AppUser user = AppUser.empty();

  _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            _showMessage(state.error);
          }
          if (state is HomeUserLoaded) {
            user = state.user;
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingScreen(user);
          }
          if (state is HomeError) {
            return ErrorScreen(error: state.error);
          }
          if (state is HomeUserLoaded) {
            return _buildLoadingScreen(state.user);
          }
          if (state is HomeLoaded) {
            return _buildBody(state);
          }
          return Container();
        },
      ),
    );
  }

  _buildHeader() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _buildLoadingScreen(AppUser user) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: [
              const SizedBox(height: 8),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(HomeLoaded state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Enter Details of the Event',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            Text(
              'Set the cover image by clicking on the box below',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  _buildImagePicker() {}
}
