import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color selectedColor;
  final Color unselectedColor;
  final FontWeight selectedWeight;
  final FontWeight unselectedWeight;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.selectedColor = Colors.black,
    this.unselectedColor = Colors.black54,
    this.selectedWeight = FontWeight.bold,
    this.unselectedWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? selectedColor : unselectedColor,
          fontWeight: isSelected ? selectedWeight : unselectedWeight,
        ),
      ),
    );
  }
}
