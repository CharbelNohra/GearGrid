// lib/features/auth/widgets/otp_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final double width;
  final double height;

  const OTPInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.width = 50,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colors.error,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: colors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}