import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import 'auth_icon_container.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Function(String) onResetEmailSent;
  final Function(String) onError;
  final Function(String) onSuccess;
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({
    super.key,
    required this.onResetEmailSent,
    required this.onError,
    required this.onSuccess,
    required this.onBackToLogin,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
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

  void _sendResetEmail() async {
    final email = emailController.text.trim();

    if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call to send reset email
      await Future.delayed(const Duration(seconds: 2));

      // Call your API here to send reset email
      // await AuthService.sendPasswordResetEmail(email);

      setState(() {
        isLoading = false;
      });

      _showSuccess("Verification code sent to $email");
      
      // Navigate to OTP verification
      widget.onResetEmailSent(email);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError("Failed to send verification code. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon illustration
        const AuthIconContainer(
          icon: Icons.lock_reset,
        ),
        
        const SizedBox(height: 32),

        // Title and description
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
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // Email input field
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

        const SizedBox(height: 24),

        // Send reset email button
        CustomButton(
          text: isLoading ? "Sending..." : "Send Verification Code",
          onPressed: isLoading ? () {} : _sendResetEmail,
        ),

        const SizedBox(height: 32),

        // Footer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remember your password?",
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: widget.onBackToLogin,
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ],
    );
  }
}