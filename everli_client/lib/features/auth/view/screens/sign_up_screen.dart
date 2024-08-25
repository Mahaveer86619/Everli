import 'package:everli_client/core/utils/extensions.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/screens/phone_auth_screen.dart';
import 'package:everli_client/features/auth/view/widgets/alternate_auth_card.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/core/common/widgets/text_field.dart';
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

  void _changeScreen(String routeName, {Map<String, dynamic>? arguments}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
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
    final theme = Theme.of(context);
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
            child: _buildSignUpBtn(theme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildAlternateAuthCards(theme),
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
            Navigator.pop(context);
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
          'Create Account',
          style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
        ),
        Text(
          'Sign up to start collaborating today.',
          style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onBackground,
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
    );
  }

  _buildSignUpBtn(ThemeData theme) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignedUp) {
          _changeScreen(
            '/complete-profile',
            arguments: {
              'id': state.id,
              'username': nameController.text,
              'email': emailController.text,
            },
          );
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
    );
  }

  _buildAlternateAuthCards(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
          onTap: () => _changeScreen('/sign-in'),
          child: RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                fontSize: theme.textTheme.titleMedium!.fontSize,
                color: theme.colorScheme.onBackground,
              ),
              children: [
                TextSpan(
                  text: 'Sign in',
                  style: TextStyle(
                    fontSize: theme.textTheme.titleMedium!.fontSize,
                    color: theme.colorScheme.primary,
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
    );
  }
}
