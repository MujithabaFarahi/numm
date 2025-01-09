import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/image_icon_builder.dart';

class SelectCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String icon;
  final bool isBordered;

  const SelectCard({
    required this.title,
    this.onTap,
    this.icon = '',
    this.isBordered = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: isBordered
                  ? Border.all(color: ColorPalette.mainBlue[300]!)
                  : null),
          child: InkWell(
            onTap: onTap,
            splashColor: ColorPalette.mainBlue[200],
            highlightColor: ColorPalette.mainBlue[100],
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (icon.isNotEmpty)
                        Container(
                          width: isBordered ? 42 : 48,
                          height: isBordered ? 42 : 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: isBordered
                                  ? ColorPalette.mainBlue[300]!
                                  : const Color(0xFFE9E9E9),
                            ),
                          ),
                          child: Center(
                            child: ImageIconBuilder(
                              image: icon,
                              isSelected: true,
                              selectedColor: ColorPalette.mainBlue[400]!,
                            ),
                          ),
                        ),
                      if (icon.isNotEmpty)
                        const SizedBox(
                          width: 16,
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ImageIconBuilder(
                    image: 'assets/icons/arrow_right_filled.png',
                    isSelected: true,
                    selectedColor: ColorPalette.mainBlue[400]!,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
