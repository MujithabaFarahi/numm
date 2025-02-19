import 'package:flutter/material.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BagList extends StatelessWidget {
  final String name;
  final String id;
  final String garment;
  final String? orderQuantity;
  final String dealer;
  final bool isLoading;
  final bool? isDaraz;
  final VoidCallback? onTap;

  const BagList({
    super.key,
    required this.name,
    required this.id,
    this.garment = '',
    this.orderQuantity,
    this.dealer = '',
    this.isLoading = false,
    this.isDaraz,
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
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isDaraz != null)
                    isDaraz!
                        ? const Text(
                            "Daraz",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            dealer,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  if (orderQuantity != null)
                    SizedBox(
                      child: Text(
                        orderQuantity!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      child: Text(
                        garment[0],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
