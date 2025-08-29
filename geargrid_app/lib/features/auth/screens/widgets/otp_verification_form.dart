// lib/features/auth/widgets/otp_verification_form.dart
import 'package:flutter/material.dart';
import '../../../../common/widgets/otp_input_field.dart';

class OTPVerificationForm extends StatefulWidget {
  final String email;
  final bool isPasswordReset;
  final VoidCallback onOTPVerified;
  final Function(String) onError;
  final Function(String) onSuccess;

  const OTPVerificationForm({
    super.key,
    required this.email,
    required this.isPasswordReset,
    required this.onOTPVerified,
    required this.onError,
    required this.onSuccess,
  });

  @override
  State<OTPVerificationForm> createState() => _OTPVerificationFormState();
}

class _OTPVerificationFormState extends State<OTPVerificationForm> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  bool isResending = false;

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = controllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      widget.onError('Please enter the full 6-digit code.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call - replace with your actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API verification
      // bool isValid = await AuthService.verifyOTP(widget.email, otp, widget.isPasswordReset);
      
      // For demo purposes, accept '123456' as valid OTP
      bool isValid = otp == '123456';

      setState(() {
        isLoading = false;
      });

      if (isValid) {
        widget.onSuccess(
          widget.isPasswordReset 
            ? 'OTP verified successfully!' 
            : 'Registration complete!'
        );
        widget.onOTPVerified();
      } else {
        widget.onError('Invalid OTP. Please try again.');
        _clearOTPFields();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      widget.onError('Verification failed. Please try again.');
      _clearOTPFields();
    }
  }

  void _clearOTPFields() {
    for (var controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  void _resendOTP() async {
    if (isResending) return;

    setState(() {
      isResending = true;
    });

    try {
      // Simulate API call - replace with your actual resend API call
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual API call
      // await AuthService.resendOTP(widget.email, widget.isPasswordReset);

      setState(() {
        isResending = false;
      });

      widget.onSuccess('Verification code sent successfully!');
      _clearOTPFields();
    } catch (e) {
      setState(() {
        isResending = false;
      });
      widget.onError('Failed to resend code. Please try again.');
    }
  }

  void _onOTPFieldChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    // Auto verify when all fields are filled
    final allFilled = controllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (allFilled && !isLoading) {
      // Add small delay to ensure UI updates before verification
      Future.delayed(const Duration(milliseconds: 100), () {
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

        // OTP input boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return OTPInputField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              onChanged: (value) => _onOTPFieldChanged(index, value),
            );
          }),
        ),

        const SizedBox(height: 40),

        // Verify button
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
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // Resend code
        TextButton(
          onPressed: isResending || isLoading ? null : _resendOTP,
          child: Text(
            isResending 
                ? 'Sending...' 
                : 'Didn\'t receive the code? Resend',
            style: TextStyle(
              color: isResending || isLoading 
                  ? colors.outline 
                  : colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}