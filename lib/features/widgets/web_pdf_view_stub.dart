import 'package:flutter/material.dart';

// Never used on mobile (doc viewers branch on kIsWeb before reaching this),
// but required so the conditional import compiles off the web.
Widget buildWebPdfView({required String url}) => const SizedBox.shrink();
