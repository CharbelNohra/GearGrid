import 'package:flutter/material.dart';

class RegistrationNavigation extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int totalSteps;
  final bool isLoading;

  const RegistrationNavigation({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onPrevious,
    this.totalSteps = 2,
    this.isLoading = false,
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
              color:
                  isLoading
                      ? colors.outline
                      : colors.primary,
            ),
            onPressed: isLoading ? null : onPrevious,
          )
        else
          const SizedBox(width: 48),

        isLoading
            ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
            : IconButton(
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