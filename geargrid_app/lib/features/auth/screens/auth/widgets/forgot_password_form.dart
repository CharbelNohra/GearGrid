import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../core/providers/flutter_riverpod.dart';
import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../core/utils/validators.dart';
import 'auth_icon_container.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  final Function(String) onResetEmailSent;
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({
    super.key,
    required this.onResetEmailSent,
    required this.onBackToLogin,
  });

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    SnackBarHelper.showError(context, "Error", message);
  }

  void _showSuccess(String message) {
    SnackBarHelper.showSuccess(context, "Success", message);
  }

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final authController = ref.read(authControllerProvider);

    final success = await authController.resendOTP(
      email: email,
      isPasswordReset: true,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      _showSuccess("Verification code sent to $email");
      widget.onResetEmailSent(email);
    } else {
      _showError(authController.error ?? "Failed to send verification code. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AuthIconContainer(icon: Icons.lock_reset),
        const SizedBox(height: 32),
        Text(
          "Forgot Password?",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "Don't worry! Enter your email address and we'll send you a verification code to reset your password.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withAlpha(180),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        CustomTextField(
          controller: emailController,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: colors.onSurface.withAlpha(150),
            size: 20,
          ),
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: isLoading ? "Sending..." : "Send Verification Code",
          onPressed: isLoading ? () {} : _sendResetEmail,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Remember your password?", style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed: widget.onBackToLogin,
              style: TextButton.styleFrom(foregroundColor: colors.primary),
              child: const Text("Login"),
            ),
          ],
        ),
      ],
    );
  }
}