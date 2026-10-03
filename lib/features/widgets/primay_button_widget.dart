import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';

/// A modern, high-end primary button widget.
///
/// Features a subtle brand gradient, soft elevation glow,
/// 12px rounded squircle corners, smooth loading indicator,
/// and responsive press feedback.
class PrimayButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final double? bordersRadius;
  final double? borderRadius;
  final Color? textColor;
  final VoidCallback? onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final Widget? icon;
  final Widget? iconRight;
  final bool isLoading;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;

  const PrimayButtonWidget({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.gradient,
    this.bordersRadius,
    this.borderRadius,
    this.height,
    this.width,
    this.textColor,
    this.onPressed,
    this.fontSize,
    this.fontWeight,
    this.textStyle,
    this.icon,
    this.iconRight,
    this.isLoading = false,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    final radius = BorderRadius.circular(
      borderRadius ?? bordersRadius ?? 12.0,
    );

    // Modern brand gradient (Blue 500 -> Blue 700)
    final effectiveGradient = isEnabled
        ? (gradient ??
            (buttonColor == null || buttonColor == AppColore.primaryColor
                ? const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null))
        : null;

    final effectiveColor = isEnabled
        ? (effectiveGradient != null ? null : (buttonColor ?? const Color(0xFF3B82F6)))
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

    // Subtle colored elevation glow for a premium feel
    final effectiveShadow = isEnabled
        ? (boxShadow ??
            [
              BoxShadow(
                color: (buttonColor ?? const Color(0xFF3B82F6))
                    .withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ])
        : <BoxShadow>[];

    final effectiveTextColor = isEnabled
        ? (textColor ?? Colors.white)
        : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      width: width,
      height: height ?? 52.0,
      decoration: BoxDecoration(
        color: effectiveColor,
        gradient: effectiveGradient,
        borderRadius: radius,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1.0,
              )
            : null,
        boxShadow: effectiveShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: isEnabled ? onPressed : null,
          splashColor: Colors.white.withValues(alpha: 0.16),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: effectiveTextColor,
                        strokeWidth: 2.4,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            buttonText ?? '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: effectiveTextColor,
                              fontSize: fontSize ?? 15,
                              fontWeight: fontWeight ?? FontWeight.w600,
                              letterSpacing: 0.2,
                            ).merge(textStyle),
                          ),
                        ),
                        if (iconRight != null) ...[
                          const SizedBox(width: 8),
                          iconRight!,
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
