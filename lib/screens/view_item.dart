import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';

class ViewItem extends StatefulWidget {
  final String bagId;
  final String title;

  const ViewItem({
    required this.bagId,
    required this.title,
    super.key,
  });

  @override
  State<ViewItem> createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  @override
  void initState() {
    super.initState();
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(GetItemById(widget.bagId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.bag == null) {
            return Center(
              child: Text(
                state.message ?? 'Failed to load item details.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final bag = state.bag!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bag.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Garment: ${bag.garment}',
                  style: TextStyle(
                      fontSize: 16, color: ColorPalette.mainGray[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Quantity Sold: ${bag.totalQuantitySold}',
                  style: TextStyle(
                      fontSize: 16, color: ColorPalette.mainGray[500]),
                ),
                const Divider(height: 32),
                const Text(
                  'Colors and Quantities:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: bag.colors.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            'Color: ${bag.colors[index]}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bought: ${bag.quantityBought[index]}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorPalette.mainGray[500]),
                                    ),
                                    Text(
                                      'Sold: ${bag.quantitySold[index]}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorPalette.mainGray[500]),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Available: ${bag.quantity[index]}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorPalette.mainGray[500]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Created At: ${bag.createdAt.toString().split(' ')[0]}',
                        style: TextStyle(
                            fontSize: 14, color: ColorPalette.mainGray[500]),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Last Updated: ${bag.lastUpdated.toString().split(' ')[0]}',
                        style: TextStyle(
                            fontSize: 14, color: ColorPalette.mainGray[500]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
