import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/image_icon_builder.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String)? onSearch;
  final VoidCallback? onFilterTap;
  final bool isLoading;

  const CustomSearchBar({
    super.key,
    this.onSearch,
    this.onFilterTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: ColorPalette.mainBlue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageIconBuilder(
                  image: 'assets/icons/search.png',
                  isOriginal: true,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: ColorPalette.mainBlue[300],
                        selectionHandleColor: ColorPalette.primaryBlue,
                      ),
                    ),
                    child: TextField(
                      cursorColor: ColorPalette.primaryBlue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.mainGray[500],
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: onSearch,
                    ),
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: ColorPalette.mainGray[600],
                      backgroundColor: ColorPalette.mainGray[100],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: ColorPalette.mainBlue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(12),
              child: const Center(
                child: ImageIconBuilder(
                  image: 'assets/icons/filter.png',
                  isOriginal: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
