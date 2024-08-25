import 'package:everli_client/core/common/auth_gate/auth_gate.dart';
import 'package:everli_client/core/resources/helpers.dart';
import 'package:everli_client/core/utils/extensions.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/core/common/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  String id = '';
  String username = '';
  String email = '';

  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final skillsController = TextEditingController();

  final defaultBio = getRandomDefaultBio();
  final defaultSkills = getRandomSkills();

  void _changeScreen(Widget screen) {
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
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    bioController.dispose();
    skillsController.dispose();
  }

  _onSubmit() {
    if (_formkey.currentState!.validate()) {
      final myUsername =
          usernameController.text == '' ? username : usernameController.text;
      context.read<AuthBloc>().add(
            OnCompleteProfilePressed(
              id: id,
              username: myUsername.trim(),
              email: email,
              bio: bioController.text.trim(),
              skills: skillsController.text.trim(),
            ),
          );
    }
  }

  _onDefaultSubmit() {
    final myUsername =
        usernameController.text == '' ? username : usernameController.text;
    context.read<AuthBloc>().add(
          OnCompleteProfilePressed(
            id: id,
            username: myUsername.trim(),
            email: email,
            bio: defaultBio,
            skills: defaultSkills,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    id = args['id'] as String;
    username = args['username'] as String;
    email = args['email'] as String;

    return SafeArea(
      child: Scaffold(
        body: _buildBody(theme),
      ),
    );
  }

  _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildform(theme),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildContinueBtn(theme),
          ),
        ],
      ),
    );
  }

  _buildHeader(ThemeData theme) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            _onDefaultSubmit();
          },
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  _buildform(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Let's get started!",
          style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
        ),
        Text(
          'Complete your profile to Show off your skills.',
          style: theme.textTheme.titleSmall!.copyWith(
                color:
                    theme.colorScheme.onBackground.withOpacity(0.8),
              ),
        ),
        // TextFields
        const SizedBox(
          height: 30,
        ),
        Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyFormTextField(
                hintText: 'Username',
                controller: usernameController,
                keyboardType: TextInputType.name,
                label: 'Username',
                keyboardAction: TextInputAction.next,
                validator: (val) {
                  if (!val!.isValidUsername) {
                    return 'Enter a valid name.';
                  }
                  return null;
                },
                initialText: username,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Skills',
                style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              MyBigTextField(
                hintText: '$defaultSkills ...',
                controller: skillsController,
                validator: (val) {
                  if (!val!.isNotEmpty) {
                    return 'Enter a skill to get started.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Bio',
                style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              MyBigTextField(
                hintText: '$defaultBio ...',
                controller: bioController,
                validator: (val) {
                  if (!val!.isNotEmpty) {
                    return 'Enter a bio to get started.';
                  }
                  return null;
                },
                lines: 3,
              ),
              // Elevated btn
              const SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildContinueBtn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CompletedProfile) {
              _changeScreen(const AuthGate());
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return SubmitBtn(
              onPressed: () {
                _onSubmit();
              },
              text: 'Continue',
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
