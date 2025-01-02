import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BagCard extends StatelessWidget {
  final String name;
  final String id;
  final String garment;
  final int totalQuantitySold;
  final List<String> colors;
  final List<int> quantities;
  final bool isLoading;
  final VoidCallback? onTap;

  const BagCard({
    super.key,
    required this.name,
    required this.id,
    required this.garment,
    required this.totalQuantitySold,
    required this.colors,
    required this.quantities,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorPalette.mainBlue[100],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
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

                SizedBox(
                  width: 90,
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  // width: 40,
                  child: Text(
                    garment[0],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  // width: 40,
                  child: Text(
                    '$totalQuantitySold',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(colors.length, (index) {
                      final color = colors[index];
                      final quantity = quantities[index];
                      return Text(
                        '$color : $quantity',
                        style: const TextStyle(fontSize: 13),
                      );
                    }),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/updateItem', arguments: {
                      "id": id,
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
