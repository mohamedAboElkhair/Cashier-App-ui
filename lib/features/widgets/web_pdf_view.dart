import 'package:flutter/material.dart';

// Syncfusion's SfPdfViewer does not render on the Flutter web (skwasm) build:
// the PDF fetches with 200 OK but the viewer reports "Failed to load document".
// On web we render the PDF in a native browser <iframe> instead (Chrome's built-in
// PDF viewer); mobile keeps SfPdfViewer. Same HtmlElementView mechanism the app
// already uses for web images (see cors_safe_network_image).
import 'web_pdf_view_stub.dart'
    if (dart.library.html) 'web_pdf_view_web.dart' as impl;

class WebPdfView extends StatelessWidget {
  final String url;

  const WebPdfView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return impl.buildWebPdfView(url: url);
  }
}
