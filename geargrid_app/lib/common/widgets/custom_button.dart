import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Make it nullable

  const CustomButton({super.key, required this.text, this.onPressed}); // Remove required

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.outline.withValues(alpha: 0.3), // Add disabled style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed, // ElevatedButton already handles null properly
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}