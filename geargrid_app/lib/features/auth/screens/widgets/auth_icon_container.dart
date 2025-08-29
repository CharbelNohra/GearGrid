// lib/features/auth/widgets/auth_icon_container.dart
import 'package:flutter/material.dart';

class AuthIconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const AuthIconContainer({
    super.key,
    required this.icon,
    this.size = 100,
    this.iconSize = 50,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? 
               colors.primaryContainer.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? colors.primary,
      ),
    );
  }
}