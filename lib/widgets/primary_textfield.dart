import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nummlk/theme/color_pallette.dart';

class PrimaryTextfield extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final String? svgIconPath;
  final bool isLoading;
  final bool isError;
  final String? errorText;
  final bool obscureText;
  final VoidCallback? onIconPressed;

  const PrimaryTextfield({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.height = 45.0,
    this.width = double.infinity,
    this.borderRadius = 4.0,
    this.backgroundColor = Colors.transparent,
    this.borderColor = ColorPalette.primaryBlue,
    this.textColor = ColorPalette.primaryTextColor,
    this.fontSize = 13.0,
    this.fontWeight = FontWeight.w500,
    this.fontFamily = 'Outfit',
    this.svgIconPath,
    this.isLoading = false,
    this.isError = false,
    this.errorText,
    this.onIconPressed,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor,
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: ColorPalette.mainGray[600]),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16.0,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor.withOpacity(0.7), // Adjust hint text visibility
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isError ? Colors.red : borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            suffixIcon: svgIconPath != null
                ? IconButton(
                    onPressed: onIconPressed,
                    icon: SvgPicture.asset(
                      svgIconPath!,
                    ),
                  )
                : null,
          ),
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text(
              errorText ?? '$labelText you entered is invalid',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize - 2,
                fontWeight: fontWeight,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
