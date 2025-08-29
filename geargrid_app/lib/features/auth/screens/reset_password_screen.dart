// lib/features/auth/screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/reset_password_form.dart';
import 'widgets/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  void _onPasswordReset() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Password reset successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login page
    context.go('/login');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(
              title: "Reset Password",
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ResetPasswordForm(
                    email: widget.email,
                    onPasswordReset: _onPasswordReset,
                    onError: _showError,
                    onSuccess: _showSuccess,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}