import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/features/widgets/space_widgets.dart';

class PrimayButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;
  final double? bordersRadius;
  final Color? textColor;
  final Function()? onPressed;
  final double? fontSize;
  final Widget? icon;
  final Widget? iconRight;
  final bool isLoading;
  const PrimayButtonWidget({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.bordersRadius,
    this.height,
    this.width,
    this.textColor,
    this.onPressed,
    this.fontSize,
    this.icon,
    this.iconRight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColore.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(bordersRadius ?? 8),
        ),
        fixedSize: Size(width ?? 331, height ?? 56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? WidthSpaceWidgets(width: 10) : SizedBox.shrink(),

          icon != null ? icon! : const SizedBox.shrink(),

          isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: textColor ?? Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Text(
                  buttonText ?? "",
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize ?? 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          iconRight != null ? WidthSpaceWidgets(width: 10) : SizedBox.shrink(),

          iconRight != null ? iconRight! : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
