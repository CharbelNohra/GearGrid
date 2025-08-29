// lib/features/auth/widgets/login_form.dart
import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/utils/validators.dart';
import 'login_welcome_header.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final Function(String) onLoginError;
  final VoidCallback onForgotPassword;
  final VoidCallback onNavigateToRegister;

  const LoginForm({
    super.key,
    required this.onLoginSuccess,
    required this.onLoginError,
    required this.onForgotPassword,
    required this.onNavigateToRegister,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate fields
    if (password.isEmpty || email.isEmpty) {
      widget.onLoginError("All fields are required.");
      return;
    }
    
    if (!Validators.isValidEmail(email)) {
      widget.onLoginError("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call - replace with your actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API call
      // await AuthService.login(email, password);
      
      setState(() {
        isLoading = false;
      });
      
      widget.onLoginSuccess();
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      widget.onLoginError("Invalid credentials. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        const LoginWelcomeHeader(),
        const SizedBox(height: 32),

        // Email field
        CustomTextField(
          controller: emailController,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 16),

        // Password field
        CustomTextField(
          controller: passwordController,
          hintText: "Password",
          isPassword: true,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),

        // Forgot password link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onForgotPassword,
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
            ),
            child: const Text("Forgot password?"),
          ),
        ),

        const SizedBox(height: 16),

        // Login button
        CustomButton(
          text: isLoading ? "Logging in..." : "Login",
          onPressed: isLoading ? null : _login,
        ),

        const SizedBox(height: 24),

        // Register link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: widget.onNavigateToRegister,
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }
}