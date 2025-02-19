import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';

class ViewReturn extends StatefulWidget {
  final String returnId;

  const ViewReturn({
    required this.returnId,
    super.key,
  });

  @override
  State<ViewReturn> createState() => _ViewReturnState();
}

class _ViewReturnState extends State<ViewReturn> {
  @override
  void initState() {
    super.initState();
    final orderBloc = BlocProvider.of<ItemBloc>(context);
    orderBloc.add(GetReturnById(widget.returnId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Return',
        showBackButton: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.returnn == null) {
            return Center(
              child: Text(
                state.message ?? 'Failed to load return details.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final returnn = state.returnn!;
          final bags = state.bags;
          final darazOrder = returnn.darazOrder ?? true;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Return ID: ${returnn.returnId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Created At: ${returnn.createdAt.toString().split(' ')[0]}',
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
                      'Total Items: ${returnn.totalItems}',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.mainGray[500]!),
                    ),
                    darazOrder
                        ? Text(
                            'Daraz Order',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.mainGray[500]!),
                          )
                        : Text(
                            'Other Order',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.mainGray[500]!),
                          ),
                  ],
                ),
                if (returnn.orderDealer != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Order Dealer: ${returnn.orderDealer}',
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
                    children: returnn.bags
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
