import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';

class BagCard extends StatelessWidget {
  final String name;
  final String? id;
  final String garment;
  final List<String> colors;

  const BagCard({
    super.key,
    required this.name,
    this.id,
    required this.garment,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: ColorPalette.mainBlue[100],
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Image.network(
                //   'https://www.loudegg.com/wp-content/uploads/2020/10/Fred-Flintstone.jpg',
                //   fit: BoxFit.cover,
                //   width: 70,
                //   height: 70,
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return const Center(child: CircularProgressIndicator());
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Center(
                //       child: Icon(Icons.broken_image,
                //           size: 50, color: Colors.grey),
                //     );
                //   },
                // ),

                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        garment,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: colors
                            .map(
                              (color) => Text(
                                color,
                                style: const TextStyle(fontSize: 14),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
