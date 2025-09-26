import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../common/widgets/otp_input_field.dart';
import '../../../../core/services/api_services.dart';

class OTPVerificationForm extends StatefulWidget {
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
  State<OTPVerificationForm> createState() => _OTPVerificationFormState();
}

class _OTPVerificationFormState extends State<OTPVerificationForm> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;
  bool isResending = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  String _getFullPhoneNumber() {
    if (widget.registrationData != null &&
        widget.registrationData!['countryCode'] != null) {
      return '${widget.registrationData!['countryCode']}${widget.registrationData!['phone']}';
    }
    return widget.registrationData?['phone'] ?? '';
  }

  void _verifyOtp() async {
    final otp = controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      widget.onError('Please enter the full 6-digit code.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.verifyOTP(email: widget.email, otp: otp);

      setState(() => isLoading = false);

      if (result['success'] == true) {
        widget.onSuccess(widget.isPasswordReset
            ? 'OTP verified successfully!'
            : 'Registration completed successfully!');
        widget.onOTPVerified();
      } else {
        widget.onError(result['error'] ?? 'Invalid OTP. Please try again.');
        _clearOTPFields();
      }
    } catch (e) {
      setState(() => isLoading = false);
      widget.onError('Verification failed. Please try again.');
      _clearOTPFields();
    }
  }

  void _clearOTPFields() {
    for (var c in controllers) c.clear();
    focusNodes[0].requestFocus();
  }

  void _resendOTP() async {
    if (isResending) return;

    setState(() => isResending = true);

    try {
      Map<String, dynamic> result;

      if (widget.isPasswordReset) {
        result = await ApiService.forgotPassword(email: widget.email);
      } else {
        if (widget.registrationData != null) {
          result = await ApiService.register(
            fullName: widget.registrationData!['name']!,
            email: widget.registrationData!['email']!,
            password: widget.registrationData!['password']!,
            country: widget.registrationData!['country']!,
            countryCode: widget.registrationData!['countryCode']!,
            address: widget.registrationData!['address']!,
            phoneNumber: _getFullPhoneNumber(),
          );
        } else {
          throw Exception('Registration data not available');
        }
      }

      setState(() => isResending = false);

      if (result['success'] == true) {
        widget.onSuccess('Verification code sent successfully!');
        _clearOTPFields();
      } else {
        widget.onError(result['error'] ?? 'Failed to resend code. Please try again.');
      }
    } catch (e) {
      setState(() => isResending = false);
      widget.onError('Failed to resend code. Please try again.');
    }
  }

  void _onOTPFieldChanged(int index, String value) {
    if (value.length == 1 && index < 5) focusNodes[index + 1].requestFocus();
    else if (value.isEmpty && index > 0) focusNodes[index - 1].requestFocus();

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
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter the 6-digit code sent to',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.6),
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
              disabledBackgroundColor: colors.outline.withOpacity(0.3),
            ),
            child: isLoading
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
