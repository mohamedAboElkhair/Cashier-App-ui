import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/core/styling/app_styles.dart';

class CategoryItemWidget extends StatelessWidget {
  final String categoryItemName;
  final VoidCallback? onPress;
  final bool isSelected;
  const CategoryItemWidget({
    super.key,
    required this.categoryItemName,
    this.onPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8),
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: isSelected ? AppColore.primaryColor : Colors.transparent,
            border: isSelected ? null : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: Text(
            categoryItemName,
            style: AppStyles.black15BoldStyle.copyWith(
              color: isSelected ? AppColore.whiteColor : AppColore.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
