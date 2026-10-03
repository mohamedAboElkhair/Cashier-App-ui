import 'package:flutter/material.dart';

Widget buildCorsSafeNetworkImage({required String url, required BoxFit fit}) {
  return Image.network(
    url,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      return const SizedBox.shrink();
    },
  );
}
