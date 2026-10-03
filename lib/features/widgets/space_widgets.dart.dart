import 'package:flutter/material.dart';

class WidthSpaceWidgets extends StatelessWidget {
  final double width;
  const WidthSpaceWidgets({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class HightSpaceWidgets extends StatelessWidget {
  final double height;
  const HightSpaceWidgets({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
