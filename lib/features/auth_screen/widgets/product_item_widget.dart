import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_styles.dart';
import 'package:templet/features/widgets%20copy/space_widgets.dart';

class ProductItemWidget extends StatelessWidget {
  final String title;
  final String price;
  final Function()? onTap;
  final String? imageUrl;
  const ProductItemWidget({
    super.key,
    required this.title,
    required this.price,
    this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "product$title",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
                  width: 150,
                  height: 160,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            HightSpaceWidgets(height: 8),

            Text(title, maxLines: 1, style: AppStyles.black15BoldStyle),
            HightSpaceWidgets(height: 8),
            Text(price, style: AppStyles.black15BoldStyle),
          ],
        ),
      ),
    );
  }
}
