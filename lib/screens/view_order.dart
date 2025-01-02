import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';

class ViewOrder extends StatefulWidget {
  final String orderId;

  const ViewOrder({
    required this.orderId,
    super.key,
  });

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  void initState() {
    super.initState();
    final orderBloc = BlocProvider.of<ItemBloc>(context);
    orderBloc.add(GetOrderById(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Order',
        showBackButton: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.order == null) {
            return Center(
              child: Text(
                state.message ?? 'Failed to load order details.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final order = state.order!;
          final bags = state.bags;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.orderId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Created At: ${order.createdAt.toString().split(' ')[0]}',
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
                      'Total Items: ${order.totalItems}',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.mainGray[500]!),
                    ),
                    order.darazOrder
                        ? Text(
                            'Daraz Order',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.mainGray[500]!),
                          )
                        : Text(
                            'Other Order:',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.mainGray[500]!),
                          ),
                  ],
                ),
                if (order.orderDealer != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Order Dealer: ${order.orderDealer}',
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
                    children: order.bags
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
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Packagers:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...order.packagers.map((packager) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '${packager.name}: ${packager.itemsProcessed}',
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorPalette.mainGray[500]!),
                          ),
                        );
                      }),
                    ],
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
