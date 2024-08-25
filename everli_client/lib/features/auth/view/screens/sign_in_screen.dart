import 'package:everli_client/core/utils/extensions.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/screens/phone_auth_screen.dart';
import 'package:everli_client/features/auth/view/widgets/alternate_auth_card.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/core/common/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _changeScreen(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onSubmit() {
    if (_formkey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInEvent(
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
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, -> does not work
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildform(),
              ),
              const SizedBox(height: 110),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSignInBtn(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildAlternateAuthCards(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  _buildform() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Hi, Welcome back!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        Text(
          'Sign in to start collaborating today.',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        // TextFields
        const SizedBox(
          height: 60,
        ),
        Form(
          key: _formkey,
          child: Column(
            children: [
              MyFormTextField(
                hintText: 'example@gmail.com',
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
                hintText: 'password',
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
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _buildSignInBtn() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignedIn) {
          _changeScreen('/auth-gate');
        } else if (state is AuthError) {
          _showMessage(state.error);
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
          text: 'Sign In',
        );
      },
    );
  }

  _buildAlternateAuthCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: 40),
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
          onTap: () => _changeScreen('/sign-up'),
          child: RichText(
            text: TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              children: [
                TextSpan(
                  text: 'Sign up',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
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
    );
  }
}
