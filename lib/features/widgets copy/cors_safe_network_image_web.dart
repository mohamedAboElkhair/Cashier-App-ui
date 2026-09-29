import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

final Set<String> _registeredViewTypes = <String>{};

String _fitToCssObjectFit(BoxFit fit) {
  switch (fit) {
    case BoxFit.fill:
      return 'fill';
    case BoxFit.contain:
      return 'contain';
    case BoxFit.cover:
      return 'cover';
    case BoxFit.fitWidth:
      return 'contain';
    case BoxFit.fitHeight:
      return 'contain';
    case BoxFit.none:
      return 'none';
    case BoxFit.scaleDown:
      return 'scale-down';
  }
}

Widget buildCorsSafeNetworkImage({required String url, required BoxFit fit}) {
  final encoded = base64Url.encode(utf8.encode(url)).replaceAll('=', '');
  final viewType = 'cors-safe-img-$encoded';

  if (!_registeredViewTypes.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final image = html.ImageElement()
        ..src = url
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = _fitToCssObjectFit(fit)
        ..style.display = 'block';
      return image;
    });
    _registeredViewTypes.add(viewType);
  }

  return HtmlElementView(viewType: viewType);
}
