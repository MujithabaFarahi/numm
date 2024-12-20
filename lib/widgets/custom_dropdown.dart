import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';

class CustomDropdown extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? value;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final FontWeight fontWeight;
  final BoxDecoration? decoration;
  final List<String>? options;
  final ValueChanged<String>? onChanged;

  const CustomDropdown({
    super.key,
    this.hintText,
    this.labelText,
    this.value,
    this.height = 48.0,
    this.width = double.infinity,
    this.borderRadius = 4.0,
    this.backgroundColor = Colors.transparent,
    this.textColor = const Color(0xFF9E9E9E),
    this.borderColor = ColorPalette.primaryBlue,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w500,
    this.decoration,
    this.options,
    this.onChanged,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: options!.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  onChanged!(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: (options != null) ? () => _showOptions(context) : null,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: value?.isNotEmpty == true ? labelText : null,
            labelStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            height: height - 32,
            child: Text(
              value?.isNotEmpty == true ? value! : hintText ?? '',
              style: TextStyle(
                color: value?.isEmpty ?? true
                    ? textColor
                    : ColorPalette.primaryTextColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
