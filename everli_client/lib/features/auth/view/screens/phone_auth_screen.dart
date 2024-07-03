import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/screens/sign_in_screen.dart';
import 'package:everli_client/features/auth/view/screens/sign_up_screen.dart';
import 'package:everli_client/features/auth/view/widgets/alternate_auth_card.dart';
import 'package:everli_client/features/auth/view/widgets/submit_btn.dart';
import 'package:everli_client/features/auth/view/widgets/text_field.dart';
import 'package:everli_client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _formkey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String verificationId = '';

  void _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _onContinue() {
    context.read<AuthBloc>().add(OnOtpAuthPressed(
          phoneNumber: phoneController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is FillingOtp) {
                return _buildOtpBody(state.verificationId);
              } else if (state is FillingNumber) {
                return _buildPhoneNumberBody();
              }
              return _loading();
            },
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text('Phone Authentication'),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: true,
    );
  }

  _loading() {
  return Center(
    child: Lottie.asset(
      'assets/lottie/loading_screen.json',
      repeat: true,
    ),
  );
}

  _buildPhoneNumberBody() {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, -> does not work
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Enter your mobile number.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Text(
                'We will send you a confirmation code.',
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
                    MyPhoneField(
                      hintText: '925-551-6904',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      label: 'Phone Number',
                      keyboardAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SignedIn) { //! placeholder
                    _changeScreen(const AuthGate());
                  } else if (state is AuthError) {
                    _showMessage(state.error);
                  } else if (state is AuthOtpSent) {
                    _showMessage(state.message);
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
                      _onContinue();
                    },
                    text: 'Continue',
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              AlternateAuthCard(
                text: 'Email & Password',
                iconPath: 'assets/icons/email.svg',
                onTap: () {
                  _changeScreen(const SignInScreen());
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
                onTap: () => _changeScreen(const SignUpScreen()),
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign up',
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
          ),
        ],
      ),
    );
  }

  _buildOtpBody(String verificationId) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, -> does not work
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Enter code sent to your phone..',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Text(
                'We sent you a confirmation code.',
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
                    PinCodeField(otpController: otpController),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SignedIn) { //! placeholder
                    _changeScreen(const AuthGate());
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
                      context.read<AuthBloc>().add(PhoneAuthEvent(
                            verificationId: verificationId,
                            otp: otpController.text,
                          ));
                    },
                    text: 'Submit',
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              AlternateAuthCard(
                text: 'Email & Password',
                iconPath: 'assets/icons/email.svg',
                onTap: () {
                  Navigator.pop(context);
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
                onTap: () => _changeScreen(const SignUpScreen()),
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign up',
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
          ),
        ],
      ),
    );
  }
}
