import 'package:everli_client_v2/common/widgets/text_field.dart';
import 'package:everli_client_v2/core/utils/extensions.dart';
import 'package:everli_client_v2/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:everli_client_v2/features/auth/presentation/widgets/submit_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  int step = 0;

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

  _onContinue() {
    if (_formkey.currentState!.validate()) {
      if (step == 0) {
        // send otp
        context
            .read<AuthBloc>()
            .add(SendPassResetOtpEvent(email: emailController.text));
      } else if (step == 1) {
        // verify otp
        context.read<AuthBloc>().add(VerifyOtpEvent(
              code: otpController.text,
              email: emailController.text,
            ));
      } else {
        // reset pass
        context.read<AuthBloc>().add(ResetPassEvent(
              email: emailController.text,
              password: passwordController.text,
            ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    otpController.dispose();
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
            child: _buildEmailForm(theme),
          ),
          const SizedBox(height: 340),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSignInBtn(theme),
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

  _buildEmailForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        Text(
          'Don\'t worry, it happens to the best of us.',
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        // TextFields
        const SizedBox(
          height: 60,
        ),
        if (step == 0)
          Form(
            key: _formkey,
            child: MyFormTextField(
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
          ),
        if (step == 1)
          Form(
            key: _formkey,
            child: PinCodeField(
              otpController: otpController,
            ),
          ),
        if (step == 2)
          Form(
            key: _formkey,
            child: Column(
              children: [
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
                const SizedBox(height: 16),
                MyFormTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Confirm Password',
                  keyboardAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (!val!.isValidPassword) {
                      return 'Enter a valid password.';
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  _buildSignInBtn(ThemeData theme) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          _changeScreen('/sign-in', isReplacement: true);
        } else if (state is SentPassResetCode) {
          _showMessage('Code sent');
          setState(() {
            step = 1;
          });
        } else if (state is VerifiedPassResetCode) {
          _showMessage('Code is valid');
          setState(() {
            step = 2;
          });
        } else if (state is PassResetCodeError) {
          setState(() {
            step = 0;
          });
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
          text: 'Submit',
        );
      },
    );
  }
}
