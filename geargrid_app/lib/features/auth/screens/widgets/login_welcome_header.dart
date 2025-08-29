// lib/features/auth/widgets/login_welcome_header.dart
import 'package:flutter/material.dart';

class LoginWelcomeHeader extends StatelessWidget {
  final String? welcomeMessage;
  final String? subtitle;

  const LoginWelcomeHeader({super.key, this.welcomeMessage, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            welcomeMessage ?? "Welcome back 👋",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle ?? "Log in to your account",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
