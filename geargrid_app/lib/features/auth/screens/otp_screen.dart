import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final otpController = TextEditingController();

  void verifyOtp() {
    final otp = otpController.text.trim();
    // For example, call API with otp, email or phone number

    // On success, navigate to home or next step
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colors.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Enter the OTP sent to your phone or email',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: verifyOtp,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}