import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';

class ImageIconBuilder extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color iconColor;
  final Color selectedColor;
  final bool isSelected;

  const ImageIconBuilder({
    super.key,
    required this.image,
    this.height = 24,
    this.width = 24,
    this.backgroundColor = Colors.transparent,
    this.iconColor = ColorPalette.primaryTextColor,
    this.selectedColor = ColorPalette.primaryBlue,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset(
          image,
          color: isSelected ? selectedColor : iconColor,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
