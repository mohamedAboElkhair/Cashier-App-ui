import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? iconPath;
  final double? widthContainer;
  final double? heightContainer;

  const CustomIconButton({
    super.key,
    this.onTap,
    this.iconPath,
    this.heightContainer,
    this.widthContainer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: widthContainer ?? 105,
        height: heightContainer ?? 56,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xffE8ECF4), width: 1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Center(
          child: SvgPicture.asset(iconPath ?? "AppAssets.facebookSvgIcon"),
        ),
      ),
    );
  }
}
