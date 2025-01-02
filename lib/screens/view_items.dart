import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_card.dart';
import 'package:nummlk/widgets/search_bar.dart';

class ViewItems extends StatefulWidget {
  const ViewItems({super.key});

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  final List<String> _dropdownOptions = ['All', 'Lulu', 'Naleem', 'Akram'];

  Stream<QuerySnapshot>? bagStream;

  @override
  void initState() {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllItems());

    super.initState();
  }

  void _showOptions(BuildContext context, List<String> options) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  final itemBloc = BlocProvider.of<ItemBloc>(context);
                  itemBloc.add(SortByGarment(option));
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Items',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/additem');
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
            BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                return CustomSearchBar(
                  isLoading: state.isLoading,
                  onFilterTap: () {
                    _showOptions(context, _dropdownOptions);
                  },
                  onSearch: (query) {
                    final itemBloc = BlocProvider.of<ItemBloc>(context);
                    itemBloc.add(SearchItems(query));
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child:
                  BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
                if (state.isLoading && state.bags.isEmpty) {
                  return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const BagCard(
                          isLoading: true,
                          id: 'id',
                          name: 'name',
                          garment: 'garment',
                          colors: ['Colors', 'Color'],
                          quantities: [0, 0],
                          totalQuantitySold: 0,
                        );
                      });
                } else if (state.bags.isEmpty) {
                  return const Center(child: Text("No bags found."));
                } else if (state.bags.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.bags.length,
                    itemBuilder: (context, index) {
                      Bag ds = state.bags[index];

                      return BagCard(
                        id: ds.id,
                        name: ds.name,
                        garment: ds.garment,
                        colors: ds.colors,
                        quantities: ds.quantity,
                        totalQuantitySold: ds.totalQuantitySold,
                        onTap: () {
                          Navigator.pushNamed(context, '/viewItem', arguments: {
                            'bagId': ds.id,
                            'title': ds.name,
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
