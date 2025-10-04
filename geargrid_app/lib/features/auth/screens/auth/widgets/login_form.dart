import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../core/providers/flutter_riverpod.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/utils/snackbar_helper.dart';
import 'login_welcome_header.dart';

class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onForgotPassword;
  final VoidCallback onNavigateToRegister;

  const LoginForm({
    super.key,
    required this.onLoginSuccess,
    required this.onForgotPassword,
    required this.onNavigateToRegister, required void Function(String message) onLoginError,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      SnackBarHelper.showError(context, "Validation Error", "All fields are required.");
      return;
    }

    if (!Validators.isValidEmail(email)) {
      SnackBarHelper.showError(context, "Validation Error", "Please enter a valid email.");
      return;
    }

    final authController = ref.read(authControllerProvider);
    
    final success = await authController.login(email: email, password: password);

    if (success) {
      if (!mounted) return;
      if (authController.currentUser?.role == 'admin') {
        SnackBarHelper.showError(
          context,
          "Access Denied",
          "This app is for clients only. Admin access is not allowed.",
        );
        await authController.logout();
        return;
      }
      widget.onLoginSuccess();
    } else {
      if (!mounted) return;
      SnackBarHelper.showError(
        context,
        "Login Failed",
        authController.error ?? "An error occurred. Please try again.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final isLoading = authController.isLoading;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        const LoginWelcomeHeader(),
        const SizedBox(height: 32),

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

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onForgotPassword,
            style: TextButton.styleFrom(foregroundColor: colors.primary),
            child: const Text("Forgot password?"),
          ),
        ),
        const SizedBox(height: 16),

        CustomButton(
          text: isLoading ? "Logging in..." : "Login",
          onPressed: isLoading ? null : _login,
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?", style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed: widget.onNavigateToRegister,
              style: TextButton.styleFrom(foregroundColor: colors.primary),
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }
}