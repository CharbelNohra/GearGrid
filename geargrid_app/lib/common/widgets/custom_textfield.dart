import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool showPasswordToggle;
  final InputBorder? border;
  final bool readOnly;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.showPasswordToggle = true,
    this.border,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword && widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        onPressed: _togglePasswordVisibility,
      );
    }
    
    if (widget.suffixIcon != null) {
      return widget.onSuffixTap != null
          ? IconButton(
              icon: widget.suffixIcon!,
              onPressed: widget.onSuffixTap,
            )
          : widget.suffixIcon;
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPhone = widget.keyboardType == TextInputType.number || 
                   widget.keyboardType == TextInputType.phone;

    // Default border if none provided
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );

    // Different styles for readOnly vs editable states
    final fillColor = widget.readOnly 
        ? colorScheme.surface.withValues(alpha: 0.5)  // Dimmed background when read-only
        : colorScheme.surface;

    final textStyle = TextStyle(
      color: widget.readOnly 
          ? colorScheme.onSurface.withValues(alpha: 0.6)  // Dimmed text when read-only
          : colorScheme.onSurface,
    );

    return TextField(
      controller: widget.controller,
      readOnly: widget.readOnly, // THIS IS THE IMPORTANT LINE - it was missing!
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      inputFormatters: isPhone 
        ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]'))]
        : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: widget.border ?? defaultBorder,
        focusedBorder: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.readOnly 
                ? colorScheme.outline  // Different border color when read-only
                : colorScheme.primary,
            width: widget.readOnly ? 1 : 3,
          ),
        ),
        prefixText: widget.prefixText,
        prefixStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
      ),
      style: textStyle,
    );
  }
}