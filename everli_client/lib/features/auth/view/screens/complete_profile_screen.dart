import 'package:everli_client/core/utils/extensions.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/features/auth/view/widgets/text_field.dart';
import 'package:everli_client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String id;
  final String username;
  final String email;
  const CompleteProfileScreen({
    super.key,
    required this.id,
    required this.username,
    required this.email,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final skillsController = TextEditingController();

  void _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  _onSubmit() {
    if (_formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            OnCompleteProfilePressed(
              id: widget.id,
              username: usernameController.text,
              email: widget.email,
              bio: bioController.text,
              skills: skillsController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBody(),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text('Sign Up'),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: true,
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, -> does not work
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Let's get started!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Text(
                'Complete your profile to Show off your skills.',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
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
                      initialText: widget.username,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Skills',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    MyBigTextField(
                      hintText: 'communication, design, coding, ...',
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    MyBigTextField(
                      hintText: 'Bio',
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
          ),
          Column(
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
          )
        ],
      ),
    );
  }
}
