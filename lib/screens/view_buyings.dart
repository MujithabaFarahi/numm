import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/buying_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_list.dart';
import 'package:nummlk/widgets/range_picker.dart';
import 'package:nummlk/widgets/search_bar.dart';

class ViewBuyings extends StatefulWidget {
  const ViewBuyings({super.key});

  @override
  State<ViewBuyings> createState() => _ViewBuyingsState();
}

class _ViewBuyingsState extends State<ViewBuyings> {
  @override
  void initState() {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllBuyings());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Buyings',
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(
            '/addBag',
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
            CustomSearchBar(
              onFilterTap: () {
                showDateRangePickerDialog(context);
              },
              onSearch: (query) {
                // final itemBloc = BlocProvider.of<ItemBloc>(context);
                // itemBloc.add(SearchItems(query));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child:
                  BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
                if (state.isLoading && state.buyings.isEmpty) {
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
                } else if (state.buyings.isEmpty) {
                  return const Center(child: Text("No Buyings found."));
                } else if (state.buyings.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.buyings.length,
                    itemBuilder: (context, index) {
                      Buying ds = state.buyings[index];

                      return BagList(
                        id: ds.id,
                        name: ds.createdAt.toString().split(' ')[0],
                        isDaraz: false,
                        dealer: ds.garment ?? 'null',
                        orderQuantity: ds.totalItems.toString(),
                        onTap: () {
                          Navigator.pushNamed(context, '/viewBuying',
                              arguments: {
                                'buyingId': ds.id,
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
