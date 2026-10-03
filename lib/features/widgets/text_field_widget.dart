import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final double? width;
  final double? height;
  final bool? isPassword;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final Iterable<String>? autofillHints;
  final Color? fillColor;

  const TextFieldWidget({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.width,
    this.isPassword,
    this.controller,
    this.validator,
    this.height,
    this.keyboardType,
    this.autovalidateMode,
    this.maxLines,
    this.autofillHints,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return SizedBox(
      width: width ?? 331,
      height: height ?? 60,
      child: TextFormField(
        // `maxLines` was only ever wired to `minLines` here, leaving the
        // inner field's actual `maxLines` at TextFormField's own default (1).
        // That's harmless while every caller passes null (minLines: null,
        // maxLines: 1 — unchanged), but the first caller to pass e.g.
        // `maxLines: 3` for a real multi-line box (penalties issue-note,
        // Task 8) would hit `minLines: 3, maxLines: 1` and trip Flutter's
        // `maxLines >= minLines` assertion. Wiring maxLines through (falling
        // back to 1, matching the previous implicit default) fixes that
        // without changing behavior for any existing single-line caller.
        minLines: maxLines,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller ?? TextEditingController(),
        validator: validator,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        autofillHints: autofillHints,
        cursorColor: scheme.primary,
        autofocus: false,
        obscureText: isPassword ?? false,
        // Typed text must contrast the fill in BOTH themes (was inheriting the
        // near-white dark body color onto a light fill -> invisible data).
        style: TextStyle(
          color: fillColor != null
              ? Colors.black
              : (isDark ? scheme.onSurface : Colors.black),
        ),
        decoration: InputDecoration(
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xff8b93a7) : const Color(0xff8391A1),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColore.welletFlap, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? AppColore.welletFlap : const Color(0xffEBECF4),
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor:
              fillColor ??
              (isDark ? const Color(0xff1b2130) : const Color(0xffF7F8F9)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
