// lib/features/auth/widgets/registration_step_one.dart
import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_textfield.dart';
import 'step_header.dart';

class RegistrationStepOne extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegistrationStepOne({
    super.key,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const StepHeader(
          currentStep: 1,
          totalSteps: 2,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          hintText: "Email",
          prefixIcon: Icon(
            Icons.email_outlined,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: nameController,
          hintText: "Full Name",
          prefixIcon: Icon(
            Icons.person_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          hintText: "Password",
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          isPassword: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: "Confirm Password",
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          isPassword: true,
        ),
      ],
    );
  }
}