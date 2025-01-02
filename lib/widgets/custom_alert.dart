import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/image_icon_builder.dart';
import 'package:nummlk/widgets/primary_button.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final String iconPath;
  final Color iconBackgroundColor;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  const CustomAlert({
    super.key,
    required this.title,
    required this.message,
    this.iconPath = "assets/icons/bin.png",
    this.iconBackgroundColor = const Color(0xFF0A0740),
    required this.onConfirm,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(12),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Wrap(
            runSpacing: 24,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor: iconBackgroundColor,
                    radius: 30,
                    child: Container(
                      width: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: ImageIconBuilder(
                          image: iconPath,
                          isSelected: true,
                          selectedColor: Colors.white,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6D6D6D),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  PrimaryButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop();
                    },
                    text: confirmText,
                    height: 42,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  PrimaryButton(
                    backgroundColor: Colors.white,
                    borderColor: ColorPalette.primaryBlue,
                    foregroundColor: ColorPalette.primaryBlue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: cancelText,
                    height: 42,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
