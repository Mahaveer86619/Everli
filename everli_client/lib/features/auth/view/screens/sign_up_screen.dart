import 'package:everli_client/core/utils/extensions.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/screens/complete_profile_screen.dart';
import 'package:everli_client/features/auth/view/screens/phone_auth_screen.dart';
import 'package:everli_client/features/auth/view/screens/sign_in_screen.dart';
import 'package:everli_client/features/auth/view/widgets/alternate_auth_card.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/features/auth/view/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
            SignUpEvent(
              username: nameController.text,
              email: emailController.text,
              password: passwordController.text,
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
                'Create Account',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Text(
                'Sign up to start collaborating today.',
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
                  children: [
                    MyFormTextField(
                      hintText: 'Username',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      label: 'Username',
                      keyboardAction: TextInputAction.next,
                      validator: (val) {
                        if (!val!.isValidUsername) {
                          return 'Enter a valid name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyFormTextField(
                      hintText: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      keyboardAction: TextInputAction.next,
                      validator: (val) {
                        if (!val!.isValidEmail) {
                          return 'Enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyFormTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      label: 'Password',
                      keyboardAction: TextInputAction.done,
                      obscureText: true,
                      validator: (val) {
                        if (!val!.isValidPassword) {
                          return 'Enter a valid password.';
                        }
                        return null;
                      },
                    ),
                    // Elevated btn
                    const SizedBox(
                      height: 90,
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
                  if (state is SignedUp) {
                    _changeScreen(CompleteProfileScreen(
                      id: state.id,
                      username: nameController.text,
                      email: emailController.text,
                    ));
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
                    text: 'Sign Up',
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              AlternateAuthCard(
                text: 'Phone Number',
                iconPath: 'assets/icons/phone.svg',
                onTap: () {
                  context.read<AuthBloc>().add(OnPhoneAuthPressed());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhoneAuthScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AlternateAuthCard(
                text: 'Google Account',
                iconPath: 'assets/icons/google.svg',
                onTap: () {},
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _changeScreen(const SignInScreen()),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
