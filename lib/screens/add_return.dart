import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_list.dart';
import 'package:nummlk/widgets/custom_dropdown.dart';
import 'package:nummlk/widgets/custom_toast.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:nummlk/widgets/search_bar.dart';

class AddReturn extends StatefulWidget {
  const AddReturn({super.key});

  @override
  State<AddReturn> createState() => _AddReturnState();
}

class _AddReturnState extends State<AddReturn> {
  final List<String> _dropdownOptions = ['All', 'Lulu', 'Naleem', 'Akram'];
  String? selectedBagId;
  String? selectedBagName;
  String? selectedColor;
  int quantity = 1;
  List<Bag> bags = [];

  final Map<String, Map<String, int>> cart = {};

  @override
  void initState() {
    super.initState();
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllItems());
  }

  void _addToCart(String bagName) {
    if (selectedBagId == null || selectedColor == null) {
      CustomToast.show(
        'Please select a bag and a color',
        bgColor: Colors.red,
      );

      return;
    }

    setState(() {
      if (!cart.containsKey(selectedBagId)) {
        cart[selectedBagId!] = {};
      }
      cart[selectedBagId!]![selectedColor!] = quantity;
      selectedColor = null;
      quantity = 1;
    });

    CustomToast.show(
      '$bagName added to Return',
    );
  }

  int getTotalQuantity() {
    int total = 0;
    for (var bag in cart.values) {
      for (var qty in bag.values) {
        total += qty;
      }
    }
    return total;
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
        title: 'Add Return',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedBagId == null)
              CustomSearchBar(
                onFilterTap: () {
                  _showOptions(context, _dropdownOptions);
                },
                onSearch: (query) {
                  final itemBloc = BlocProvider.of<ItemBloc>(context);
                  itemBloc.add(SearchItems(query));
                },
              ),
            if (selectedBagId == null)
              const SizedBox(
                height: 12,
              ),
            if (selectedBagId == null)
              Expanded(
                child:
                    BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
                  if (state.isLoading && state.bags.isEmpty) {
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
                  } else if (state.bags.isEmpty && !state.isLoading) {
                    return const Center(child: Text("No bags found."));
                  } else if (state.bags.isNotEmpty) {
                    if (bags.isEmpty) {
                      bags = state.bags;
                    }

                    return ListView.builder(
                      itemCount: state.bags.length,
                      itemBuilder: (context, index) {
                        Bag ds = state.bags[index];

                        return BagList(
                          id: ds.id,
                          name: ds.name,
                          garment: ds.garment,
                          onTap: () {
                            final selectedBag =
                                bags.firstWhere((bag) => bag.id == ds.id);

                            setState(() {
                              selectedBagName = ds.name;
                              selectedBagId = ds.id;
                              selectedColor = selectedBag.colors[0];
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
            const SizedBox(
              height: 12,
            ),
            if (selectedBagId != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedBagName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PrimaryButton(
                    text: 'Select Another Bag',
                    onPressed: () {
                      setState(() {
                        selectedBagId = null;
                        selectedBagName = null;
                      });
                    },
                    height: 25,
                    width: 150,
                    backgroundColor: Colors.transparent,
                    borderColor: ColorPalette.primaryBlue,
                    foregroundColor: ColorPalette.primaryBlue,
                  )
                ],
              ),
            if (selectedBagId != null)
              const SizedBox(
                height: 12,
              ),
            if (selectedBagId != null)
              CustomDropdown(
                hintText: 'Select Color',
                labelText: 'Color',
                value: selectedColor,
                options:
                    bags.firstWhere((bag) => bag.id == selectedBagId!).colors,
                onChanged: (value) {
                  setState(() {
                    selectedColor = value;
                    quantity = 1;
                  });
                },
              ),
            if (selectedColor != null && selectedBagId != null)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            if (selectedColor != null && selectedBagId != null)
              const SizedBox(height: 16),
            if (selectedColor != null && selectedBagId != null)
              PrimaryButton(
                onPressed: () {
                  _addToCart(selectedBagName!);
                },
                text: 'Add Bag',
              ),
            if (selectedColor != null &&
                selectedBagId != null &&
                cart.isNotEmpty)
              const SizedBox(height: 16),
            if (cart.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Quantity: ${getTotalQuantity()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: cart.entries.map((entry) {
                          final bagId = entry.key;
                          final bagName =
                              bags.firstWhere((bag) => bag.id == bagId).name;
                          final colorsAndQuantities = entry.value;

                          return Dismissible(
                            key: Key(bagId),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              cart.remove(bagId);
                            },
                            background: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Material(
                                elevation: 1,
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bag: $bagName',
                                      style: const TextStyle(
                                        fontSize: 16,
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            if (cart.isNotEmpty)
              PrimaryButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/confirmReturn', arguments: {
                    'cart': cart,
                  });
                },
                text: 'Next',
              ),
          ],
        ),
      ),
    );
  }
}
