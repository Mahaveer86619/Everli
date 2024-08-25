import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/widgets/error_screen.dart';
import 'package:everli_client/core/common/widgets/text_field.dart';
import 'package:everli_client/core/themes/pallet.dart';
import 'package:everli_client/features/app/presentation/home/bloc/home_bloc.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/confirm_button.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/create_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinEventScreen extends StatefulWidget {
  const JoinEventScreen({super.key});

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  AppUser user = AppUser.empty();

  final codeController = TextEditingController();

  void _changeScreen(String routeName, {Map<String, dynamic>? arguments}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
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

  _onJoin(String code) async {
    context.read<HomeBloc>().add(JoinEvent(
          userId: user.id,
          code: code,
        ));
  }

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(FetchAppUser());
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
              'Enter Invitation code',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            Text(
              'Enter the code sent to you by the Event Admin',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
            ),
            const SizedBox(height: 32),
            PinCodeField(otpController: codeController),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConfirmButton(
                  text: 'Join',
                  onTap: () {
                    _onJoin(codeController.text);
                    // after joining, go to event screen
                  },
                  color: Pallete.greenColor,
                ),
              ],
            ),
            const SizedBox(height: 48),
            Divider(
              height: 3,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: 48),
            CreateEventCard(
              onTap: () {
                _changeScreen('/home/create-event');
              },
            ),
          ],
        ),
      ),
    );
  }
}
