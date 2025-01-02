import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nummlk/theme/color_pallette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: title.isNotEmpty
            ? Text(
                title,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.mainGray[600]),
              )
            : null,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: showBackButton
            ? IconButton(
                icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null,
        actions: <Widget>[
          onMorePressed != null
              ? IconButton(
                  icon: SvgPicture.asset('assets/icons/ellipsis.svg'),
                  onPressed: onMorePressed)
              : const SizedBox.shrink()
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
