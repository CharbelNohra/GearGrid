import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool readOnly;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Background color and text color depending on readOnly
    final fillColor = widget.readOnly
        ? colorScheme.surface.withValues(alpha: 0.1)
        : colorScheme.surface;

    final textStyle = TextStyle(
      color: widget.readOnly
          ? colorScheme.onSurface.withValues(alpha: 0.6)
          : colorScheme.onSurface,
    );

    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabled: !widget.readOnly,
      ),
      isEmpty: widget.value == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: widget.value,
          isExpanded: true,
          hint: Text(
            widget.hintText,
            style: textStyle.copyWith(color: textStyle.color),
          ),
          items: widget.items,
          onChanged: widget.readOnly ? null : widget.onChanged,
          style: textStyle,
          iconEnabledColor: textStyle.color,
        ),
      ),
    );
  }
}