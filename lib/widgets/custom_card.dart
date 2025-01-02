import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final double borderRadius;
  final bool isLoading;

  const CustomCard({
    required this.title,
    this.onTap,
    this.isSelected = false,
    this.borderRadius = 8,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SizedBox(
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color:
                  isSelected ? ColorPalette.mainBlue[300] : ColorPalette.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: ColorPalette.primaryBlue,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              splashColor: ColorPalette.mainBlue[200],
              highlightColor: ColorPalette.mainBlue[200],
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
