import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';

class ViewBuying extends StatefulWidget {
  final String buyingId;

  const ViewBuying({
    required this.buyingId,
    super.key,
  });

  @override
  State<ViewBuying> createState() => _ViewBuyingState();
}

class _ViewBuyingState extends State<ViewBuying> {
  @override
  void initState() {
    super.initState();
    final orderBloc = BlocProvider.of<ItemBloc>(context);
    orderBloc.add(GetBuyingById(widget.buyingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Buying',
        showBackButton: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.buying == null) {
            return Center(
              child: Text(
                state.message ?? 'Failed to load buying details.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final buying = state.buying!;
          final bags = state.bags;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buying ID: ${buying.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Created At: ${buying.createdAt.toString().split(' ')[0]}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Items: ${buying.totalItems}',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.mainGray[500]!),
                    ),
                    Text(
                      '${buying.garment}',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.mainGray[500]!),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const Text(
                  'Bags in Order:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: buying.bags
                        .fold<Map<String, Map<String, int>>>({},
                            (Map<String, Map<String, int>> acc, bag) {
                          if (!acc.containsKey(bag.bagId)) {
                            acc[bag.bagId] = {};
                          }
                          acc[bag.bagId]?[bag.color] =
                              (acc[bag.bagId]?[bag.color] ?? 0) + bag.quantity;
                          return acc;
                        })
                        .entries
                        .map(
                          (entry) {
                            final bagName = bags
                                .firstWhere((bag) => bag.id == entry.key)
                                .name;
                            final colorsAndQuantities = entry.value;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bag ID: $bagName',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...colorsAndQuantities.entries.map(
                                      (colorEntry) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Color: ${colorEntry.key}'),
                                          Text('Quantity: ${colorEntry.value}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
