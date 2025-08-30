import 'package:flutter/material.dart';
import 'package:geargrid/core/utils/snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import 'widgets/auth_header.dart';
import 'widgets/otp_verification_form.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String? phoneNumber;
  final bool isPasswordReset;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    this.phoneNumber,
    this.isPasswordReset = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  void _onOTPVerified() {
    if (widget.isPasswordReset) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } else {
      _showSuccess('Registration complete!');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.go('/login');
        }
      });
    }
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
            AuthHeader(
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OTPVerificationForm(
                  email: widget.email,
                  isPasswordReset: widget.isPasswordReset,
                  onOTPVerified: _onOTPVerified,
                  onError: _showError,
                  onSuccess: _showSuccess,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}