import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_texTfield.dart';
import '../../../core/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void sendResetEmail() async {
    final email = emailController.text.trim();

    if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Call your API here to send reset email
      // await AuthService.sendPasswordResetEmail(email);

      setState(() {
        emailSent = true;
        isLoading = false;
      });

      _showSuccess("Password reset email sent successfully!");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError("Failed to send reset email. Please try again.");
    }
  }

  void resendEmail() {
    setState(() {
      emailSent = false;
    });
    sendResetEmail();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 24,
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon illustration
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          emailSent ? Icons.mark_email_read : Icons.lock_reset,
                          size: 50,
                          color: colors.primary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title and description
                      if (!emailSent) ...[
                        Text(
                          "Forgot Password?",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Don't worry! It happens. Please enter the email address associated with your account.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        // Email input field
                        CustomTextField(
                          controller: emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: colors.onSurface.withValues(alpha: 0.6),
                            size: 20,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Send reset email button
                        CustomButton(
                          text: isLoading ? "Sending..." : "Send Reset Email",
                          onPressed: isLoading ? () {} : sendResetEmail,
                        ),
                      ] else ...[
                        // Success state
                        Text(
                          "Check Your Email",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          // onTap: () => context.go('/login'),
                          onTap: () async {
                            final url = Uri.parse('https://mail.google.com/');
                            try {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not launch Gmail'),
                                ),
                              );
                            }
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurface.withValues(alpha: 0.7),
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "We have sent a password reset email to\n",
                                ),
                                TextSpan(
                                  text: emailController.text.trim(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.primaryContainer.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: colors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Next Steps:",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "• Check your email inbox\n• Click the reset link in the email\n•Create a new password\n• Check spam folder if not found",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Resend email button
                        TextButton(
                          onPressed: resendEmail,
                          child: Text(
                            "Didn't receive the email? Resend",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Back to login button
                        CustomButton(
                          text: "Back to Login",
                          onPressed: () => context.go('/login'),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Footer - only show if not in success state
                      if (!emailSent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Remember your password?",
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              style: TextButton.styleFrom(
                                foregroundColor: colors.primary,
                              ),
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
