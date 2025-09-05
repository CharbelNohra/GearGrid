import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'widgets/registration_form.dart';
import '../../../common/widgets/app_logo.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<RegistrationFormState>();

  void _onFormComplete(Map<String, String> formData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OTPVerificationScreen(
          email: formData['email']!,
          phoneNumber: formData['phone']!,
          isPasswordReset: false,
          registrationData: formData,
          onVerificationComplete: _onRegistrationComplete,
        ),
      ),
    );
  }

  void _onRegistrationComplete() {
    _showSuccess('Please log in.');
    Future.delayed(const Duration(seconds: 1), () {
      context.go('/login');
    });
  }

  void _showError(String message) {
    SnackBarHelper.showError(context, "Registration Failed", message);
  }

  void _showSuccess(String message) {
    SnackBarHelper.showSuccess(context, "Registration Completed", message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    RegistrationForm(
                      key: _formKey,
                      onComplete: _onFormComplete,
                      onError: _showError,
                      onSuccess: _showSuccess,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.primary,
                          ),
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}