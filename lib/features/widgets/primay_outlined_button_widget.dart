import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';

class PrimayOutlinedButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;
  final double? bordersRadius;
  final Color? textColor;
  final Function()? onPressed;
  final double? fontSize;
  final Color? borderColor;
  const PrimayOutlinedButtonWidget({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.bordersRadius,
    this.height,
    this.width,
    this.textColor,
    this.onPressed,
    this.fontSize,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColore.whiteColor,
        side: BorderSide(
          color: borderColor ?? AppColore.primaryColor,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(bordersRadius ?? 8),
        ),
        fixedSize: Size(width ?? 331, height ?? 56),
      ),
      child: Text(
        buttonText ?? "",
        style: TextStyle(
          color: textColor ?? AppColore.primaryColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
