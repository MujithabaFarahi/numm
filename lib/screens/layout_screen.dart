import 'package:flutter/material.dart';
import 'package:nummlk/screens/view_items.dart';
import 'package:nummlk/screens/add_order.dart';
import 'package:nummlk/screens/home_screen.dart';
import 'package:nummlk/screens/more_screen.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/image_icon_builder.dart';

class LayoutScreen extends StatefulWidget {
  final int pageIndex;
  const LayoutScreen({super.key, required this.pageIndex});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
        children: const [
          HomeScreen(),
          ViewItems(),
          AddOrder(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const ImageIconBuilder(
                      image: 'assets/icons/home.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(
                      image: 'assets/icons/home-outline.png',
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const ImageIconBuilder(
                      image: 'assets/icons/bag.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(
                      image: 'assets/icons/bag-outline.png',
                    ),
              label: 'Bags',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? const ImageIconBuilder(
                      image: 'assets/icons/add.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(
                      image: 'assets/icons/add-outline.png',
                    ),
              label: 'Add Order',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? const ImageIconBuilder(
                      image: 'assets/icons/more-outline.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(
                      image: 'assets/icons/more.png',
                    ),
              label: 'more',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorPalette.primaryBlue,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
