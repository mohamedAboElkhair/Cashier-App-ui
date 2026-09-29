import 'package:flutter/material.dart';

class HightSpaceWidgets extends StatelessWidget {
  final double height;
  const HightSpaceWidgets({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class WidthSpaceWidgets extends StatelessWidget {
  final double width;
  const WidthSpaceWidgets({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

// Additional spacing widgets can be added here

// Example usage:
// HightSpaceWidgets(height: 20),
// WidthSpaceWidgets(width: 10),

// You can also create responsive spacing widgets if needed.

// For example, a widget that adapts based on screen size:
class ResponsiveSpace extends StatelessWidget {
  final double smallHeight;
  final double largeHeight;
  const ResponsiveSpace({super.key, required this.smallHeight, required this.largeHeight});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(height: height < 600 ? smallHeight : largeHeight);
  }
}
