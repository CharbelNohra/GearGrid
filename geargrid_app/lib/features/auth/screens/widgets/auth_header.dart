// lib/features/auth/widgets/auth_header.dart
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final String? title;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    this.onBackPressed,
    this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: onBackPressed ?? () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              iconSize: 24,
            ),
          if (title != null) ...[
            const SizedBox(width: 8),
            Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}