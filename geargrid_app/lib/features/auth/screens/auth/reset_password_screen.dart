import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/snackbar_helper.dart';
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
    SnackBarHelper.showSuccess(
      context,
      "Password Reset Successful",
      "You can now log in with your new password",
    );

    context.go('/login');
  }

  void _showError(String message) {
    SnackBarHelper.showError(context, "Error", message);
  }

  void _showSuccess(String message) {
    SnackBarHelper.showSuccess(
      context,
      "Success",
      message,
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