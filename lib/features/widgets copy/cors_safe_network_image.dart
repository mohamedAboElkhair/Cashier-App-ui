import 'package:flutter/material.dart';

import 'cors_safe_network_image_stub.dart'
    if (dart.library.html) 'cors_safe_network_image_web.dart'
    as impl;

class CorsSafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CorsSafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return impl.buildCorsSafeNetworkImage(url: imageUrl, fit: fit);
  }
}
