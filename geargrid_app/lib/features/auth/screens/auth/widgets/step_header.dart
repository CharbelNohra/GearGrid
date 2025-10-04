import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? customText;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Text(
      customText ?? "Step $currentStep of $totalSteps",
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}