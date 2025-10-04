// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/otp_input_field.dart';
import '../../../../../core/providers/flutter_riverpod.dart';
import '../../../controllers/auth_controller.dart';

class OTPVerificationForm extends ConsumerStatefulWidget {
  final String email;
  final bool isPasswordReset;
  final VoidCallback onOTPVerified;
  final Function(String) onError;
  final Function(String) onSuccess;
  final Map<String, String>? registrationData;

  const OTPVerificationForm({
    super.key,
    required this.email,
    required this.isPasswordReset,
    required this.onOTPVerified,
    required this.onError,
    required this.onSuccess,
    this.registrationData,
  });

  @override
  ConsumerState<OTPVerificationForm> createState() =>
      _OTPVerificationFormState();
}

class _OTPVerificationFormState extends ConsumerState<OTPVerificationForm> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _debounceTimer;

  AuthController get _authController => ref.read(authControllerProvider);

  bool get isLoading => ref.watch(authControllerProvider).isLoading;
  bool get isResending => ref.watch(authControllerProvider).isResending;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      widget.onError('Please enter the full 6-digit code.');
      return;
    }

    final success = await _authController.verifyOTP(
      email: widget.email,
      otp: otp,
    );

    if (success) {
      widget.onSuccess(
        widget.isPasswordReset
            ? 'OTP verified successfully!'
            : 'Registration completed successfully!',
      );
      widget.onOTPVerified();
    } else {
      widget.onError(_authController.error ?? 'Invalid OTP. Please try again.');
      _clearOTPFields();
    }
  }

  Future<void> _resendOTP() async {
    _authController.clearError();

    try {
      bool success;
      success = await _authController.resendOTP(
        email: widget.email,
        isPasswordReset: widget.isPasswordReset,
      );

      if (success) {
        widget.onSuccess('Verification code sent successfully!');
        _clearOTPFields();
      } else {
        widget.onError(
          _authController.error ?? 'Failed to resend code. Please try again.',
        );
      }
    } catch (e) {
      widget.onError('Failed to resend code: ${e.toString()}');
    }
  }

  void _clearOTPFields() {
    for (var c in controllers) c.clear();
    focusNodes[0].requestFocus();
  }

  void _onOTPFieldChanged(int index, String value) {
    if (value.length == 1 && index < 5)
      focusNodes[index + 1].requestFocus();
    else if (value.isEmpty && index > 0)
      focusNodes[index - 1].requestFocus();

    _debounceTimer?.cancel();
    if (controllers.every((c) => c.text.isNotEmpty) && !isLoading) {
      _debounceTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted) _verifyOtp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'OTP Verification',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter the 6-digit code sent to',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.email,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => OTPInputField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              onChanged: (v) => _onOTPFieldChanged(index, v),
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: colors.outline.withValues(alpha: 0.3),
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(colors.onPrimary),
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: isResending || isLoading ? null : _resendOTP,
          child: Text(
            isResending ? 'Sending...' : 'Didn\'t receive the code? Resend',
            style: TextStyle(
              color: isResending || isLoading ? colors.outline : colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
