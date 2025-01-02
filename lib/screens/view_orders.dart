import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/Models/order_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_card.dart';
import 'package:nummlk/widgets/bag_list.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:nummlk/widgets/range_picker.dart';
import 'package:nummlk/widgets/search_bar.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  // final List<String> _dropdownOptions = ['All', 'Lulu', 'Naleem', 'Akram'];

  Stream<QuerySnapshot>? bagStream;

  @override
  void initState() {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllOrders());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Orders',
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/add',
            (route) => false,
          );
        },
        backgroundColor: ColorPalette.primaryBlue,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomSearchBar(
            //   onFilterTap: () {
            //     _showOptions(context, _dropdownOptions);
            //   },
            //   onSearch: (query) {
            //     final itemBloc = BlocProvider.of<ItemBloc>(context);
            //     itemBloc.add(SearchItems(query));
            //   },
            // ),
            PrimaryButton(
                text: 'text',
                onPressed: () {
                  showDateRangePickerDialog(context);
                }),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child:
                  BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
                if (state.isLoading && state.orders.isEmpty) {
                  return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const BagList(
                          isLoading: true,
                          id: 'id',
                          name: 'name',
                          garment: 'garment',
                        );
                      });
                } else if (state.orders.isEmpty) {
                  return const Center(child: Text("No orders found."));
                } else if (state.orders.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      BagOrder ds = state.orders[index];

                      return BagList(
                        id: ds.orderId,
                        name: ds.createdAt.toString().split(' ')[0],
                        isDaraz: ds.darazOrder,
                        garment: ds.totalItems.toString(),
                        onTap: () {
                          Navigator.pushNamed(context, '/viewOrder',
                              arguments: {
                                'orderId': ds.orderId,
                              });
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("An error occurred."));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
