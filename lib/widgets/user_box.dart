import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserBox extends StatelessWidget {
  final String name;
  final String id;
  final double itemsProcessed;
  final int orderDeals;
  final bool isLoading;

  const UserBox({
    super.key,
    required this.name,
    required this.id,
    required this.itemsProcessed,
    required this.orderDeals,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Skeletonizer(
        enabled: isLoading,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // color: ColorPalette.white,
            ),
            child: InkWell(
              splashColor: ColorPalette.mainBlue[100],
              highlightColor: ColorPalette.mainBlue[100],
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).pushNamed('/user', arguments: {
                  "userId": id,
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bags Packed: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${itemsProcessed..toStringAsFixed(1)}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Orders: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$orderDeals',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
