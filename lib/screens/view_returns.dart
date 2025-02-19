import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/return_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_list.dart';
import 'package:nummlk/widgets/range_picker.dart';
import 'package:nummlk/widgets/search_bar.dart';

class ViewReturns extends StatefulWidget {
  const ViewReturns({super.key});

  @override
  State<ViewReturns> createState() => _ViewReturnsState();
}

class _ViewReturnsState extends State<ViewReturns> {
  @override
  void initState() {
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllReturns());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Returns',
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(
            '/addreturn',
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
                if (state.isLoading && state.returnns.isEmpty) {
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
                } else if (state.returnns.isEmpty) {
                  return const Center(child: Text("No returnns found."));
                } else if (state.returnns.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.returnns.length,
                    itemBuilder: (context, index) {
                      Return ds = state.returnns[index];

                      return BagList(
                        id: ds.returnId,
                        name: ds.createdAt.toString().split(' ')[0],
                        isDaraz: ds.darazOrder ?? true,
                        dealer: ds.orderDealer ?? '',
                        orderQuantity: ds.totalItems.toString(),
                        onTap: () {
                          Navigator.pushNamed(context, '/viewReturn',
                              arguments: {
                                'returnId': ds.returnId,
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
