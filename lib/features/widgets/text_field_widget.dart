import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern, highly-customizable text form field widget.
///
/// Designed with sleek rounded borders (12px), subtle slate tints,
/// smooth focus states, integrated label support, and error handling
/// that avoids height clipping.
class TextFieldWidget extends StatelessWidget {
  /// Optional label displayed directly above the text field.
  final String? label;
  final TextStyle? labelStyle;
  final bool isRequired;

  /// Inner hint/placeholder text.
  final String? hintText;
  final TextStyle? hintStyle;

  /// Helper or counter text shown under the field.
  final String? helperText;

  /// Accessory widgets.
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;

  /// Dimensions & Layout.
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  /// Input behavior & State.
  final bool? isPassword;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// Validation.
  final String? Function(String?)? validator;

  /// Callbacks.
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  /// Color customization.
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? style;

  const TextFieldWidget({
    super.key,
    this.label,
    this.labelStyle,
    this.isRequired = false,
    this.hintText,
    this.hintStyle,
    this.helperText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.width,
    this.height,
    this.contentPadding,
    this.borderRadius = 12.0,
    this.isPassword,
    this.readOnly = false,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autovalidateMode,
    this.maxLines,
    this.minLines,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Palette tokens: subtle slate background & crisp borders
    final effectiveFillColor = fillColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));

    final effectiveBorderColor = borderColor ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

    final effectiveFocusedBorderColor =
        focusedBorderColor ?? scheme.primary;

    // Text color contrast check
    final effectiveTextColor = style?.color ??
        (fillColor != null
            ? (isDark && fillColor == const Color(0xFF1E293B)
                ? Colors.white
                : const Color(0xFF0F172A))
            : (isDark ? scheme.onSurface : const Color(0xFF0F172A)));

    final effectiveHintColor = hintStyle?.color ??
        (isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8));

    final radius = BorderRadius.circular(borderRadius);

    Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword ?? false,
      readOnly: readOnly,
      enabled: enabled,
      minLines: isPassword == true ? 1 : (minLines ?? maxLines),
      maxLines: isPassword == true ? 1 : (maxLines ?? 1),
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      cursorColor: effectiveFocusedBorderColor,
      cursorWidth: 1.8,
      cursorRadius: const Radius.circular(2),
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: effectiveTextColor,
      ).merge(style),
      decoration: InputDecoration(
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: effectiveHintColor,
        ).merge(hintStyle),
        helperText: helperText,
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                child: prefixIcon!,
              )
            : null,
        prefix: prefix,
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                child: suffixIcon!,
              )
            : null,
        suffix: suffix,
        filled: true,
        fillColor: enabled
            ? effectiveFillColor
            : effectiveFillColor.withValues(alpha: 0.5),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        isDense: false,
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: effectiveBorderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: effectiveFocusedBorderColor,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.8,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: effectiveBorderColor.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFEF4444),
        ),
      ),
    );

    // Apply explicit dimensions if caller provided them
    if (height != null) {
      field = SizedBox(height: height, child: field);
    }
    if (width != null) {
      field = SizedBox(width: width, child: field);
    }

    // Render top label if present
    if (label != null) {
      final defaultLabelStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
        letterSpacing: 0.1,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label!, style: defaultLabelStyle.merge(labelStyle)),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          field,
        ],
      );
    }

    return field;
  }
}
