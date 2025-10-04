import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../core/providers/flutter_riverpod.dart';
import '../../../../../core/utils/validators.dart';
import 'auth_icon_container.dart';

class ResetPasswordForm extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback onPasswordReset;
  final Function(String) onError;
  final Function(String) onSuccess;

  const ResetPasswordForm({
    super.key,
    required this.email,
    required this.onPasswordReset,
    required this.onError,
    required this.onSuccess,
  });

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends ConsumerState<ResetPasswordForm> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validatePasswords() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!Validators.isValidPassword(newPassword)) {
      widget.onError(
        "Password must be at least 8 characters, include upper/lower case letters, and a number or symbol.",
      );
      return false;
    }

    if (newPassword != confirmPassword) {
      widget.onError("Passwords do not match.");
      return false;
    }

    return true;
  }

  void _resetPassword() async {
    if (!_validatePasswords()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call to reset password
      await Future.delayed(const Duration(seconds: 2));

      final authController = ref.read(authControllerProvider);

      await authController.resetPassword(
        email: widget.email,
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      widget.onSuccess("Password reset successfully!");

      // Navigate back to login
      widget.onPasswordReset();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      widget.onError("Failed to reset password. Please try again.");
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
        const AuthIconContainer(icon: Icons.lock_person),

        const SizedBox(height: 32),

        // Title and description
        Text(
          "Create New Password",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          "Your new password must be different from your previous password.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // New Password input field
        CustomTextField(
          controller: newPasswordController,
          hintText: "New Password",
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          isPassword: true,
        ),

        const SizedBox(height: 16),

        // Confirm Password input field
        CustomTextField(
          controller: confirmPasswordController,
          hintText: "Confirm New Password",
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          isPassword: true,
        ),

        const SizedBox(height: 24),

        // Reset password button
        CustomButton(
          text: isLoading ? "Resetting..." : "Reset Password",
          onPressed: isLoading ? () {} : _resetPassword,
        ),

        const SizedBox(height: 16),

        // Password requirements info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.primaryContainer.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: colors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Password Requirements:",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "• At least 8 characters\n• Include uppercase and lowercase letters\n• Include at least one number or symbol",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
