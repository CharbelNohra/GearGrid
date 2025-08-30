import 'package:flutter/material.dart';

class RegistrationNavigation extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int totalSteps;

  const RegistrationNavigation({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onPrevious,
    this.totalSteps = 2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLastStep = currentStep >= totalSteps - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: colors.primary,
            ),
            onPressed: onPrevious,
          )
        else
          const SizedBox(width: 48),
        IconButton(
          icon: Icon(
            isLastStep ? Icons.check_circle : Icons.arrow_forward_ios,
            color: colors.primary,
            size: 28,
          ),
          onPressed: onNext,
        ),
      ],
    );
  }
}