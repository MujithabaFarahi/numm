import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:nummlk/widgets/primary_textfield.dart';

class AddBag extends StatefulWidget {
  const AddBag({super.key});

  @override
  State<AddBag> createState() => _AddBagState();
}

class _AddBagState extends State<AddBag> {
  String? selectedBagId;
  String? selectedBagName;
  String? selectedColor;
  String garment = 'Akram';
  int quantity = 1;
  List<Bag> bags = [];
  bool isLoading = false;

  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Map<String, Map<String, int>> cart = {};

  @override
  void initState() {
    super.initState();
    _quantityController.text = quantity.toString();

    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(SortByGarment(garment));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _focusNode.dispose();
    super.dispose();
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
      _quantityController.text = quantity.toString();
    });

    CustomToast.show(
      '$bagName added to order',
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

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1) {
      setState(() {
        quantity = newQuantity;
        _quantityController.text = newQuantity.toString();
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Bags',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedBagId == null)
              CustomDropdown(
                hintText: 'Select Garment',
                labelText: 'Garment',
                value: garment,
                options: const ['Akram', 'Naleem', 'Lulu'],
                onChanged: (value) {
                  final itemBloc = BlocProvider.of<ItemBloc>(context);
                  itemBloc.add(SortByGarment(value));
                  setState(() {
                    garment = value;
                  });
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
            const SizedBox(height: 12),
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
                        selectedColor = null;
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
            if (selectedBagId != null) const SizedBox(height: 12),
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
            if (selectedColor != null) const SizedBox(height: 10),
            if (selectedColor != null)
              SizedBox(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          _updateQuantity(quantity - 1);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 60,
                      child: PrimaryTextfield(
                          focusNode: _focusNode,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          hintText: 'Quantity',
                          controller: _quantityController,
                          onChanged: (value) {
                            final int? newQuantity = int.tryParse(value);
                            if (newQuantity != null && newQuantity >= 1) {
                              quantity = newQuantity;
                            }
                          }),
                    ),
                    IconButton(
                      onPressed: () {
                        _updateQuantity(quantity + 1);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            if (selectedColor != null) const SizedBox(height: 12),
            if (selectedColor != null)
              PrimaryButton(
                onPressed: () {
                  _addToCart(selectedBagName!);
                },
                text: 'Add Bag',
              ),
            if (cart.isNotEmpty) const SizedBox(height: 16),
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
            const SizedBox(
              height: 10,
            ),
            if (cart.isNotEmpty)
              PrimaryButton(
                onPressed: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  await firestore.runTransaction((transaction) async {
                    // Step 1: Read all necessary data first
                    Map<String, Map<String, dynamic>> bagsData =
                        {}; // Store all bag data

                    for (String bagId in cart.keys) {
                      final bagRef = firestore.collection('Bags').doc(bagId);

                      final bagSnapshot = await transaction.get(bagRef);

                      if (!bagSnapshot.exists) {
                        throw Exception('Bag does not exist');
                      }

                      bagsData[bagId] =
                          bagSnapshot.data() as Map<String, dynamic>;
                    }

                    // Step 2: Process the data
                    Map<String, Map<String, dynamic>> updatedBagsData = {};

                    for (String bagId in cart.keys) {
                      Map<String, dynamic> bagData = bagsData[bagId]!;
                      List<String> colors =
                          List<String>.from(bagData['colors']);
                      List<int> quantities =
                          List<int>.from(bagData['quantity']);
                      List<int> quantityBought =
                          List<int>.from(bagData['quantityBought']);

                      for (var entry in cart[bagId]!.entries) {
                        String color = entry.key;
                        int orderQuantity = entry.value;
                        int colorIndex = colors.indexOf(color);

                        if (colorIndex == -1) {
                          throw Exception('Color not found in bag');
                        }

                        // if (quantities[colorIndex] < orderQuantity) {
                        //   throw Exception('Insufficient stock for $color');
                        // }
                        quantityBought[colorIndex] += orderQuantity;
                        quantities[colorIndex] += orderQuantity;
                      }

                      updatedBagsData[bagId] = {
                        "quantity": quantities,
                        "quantityBought": quantityBought,
                      };
                    }

                    // Step 3: Perform all writes after processing
                    for (String bagId in updatedBagsData.keys) {
                      final bagRef = firestore.collection('Bags').doc(bagId);

                      transaction.update(bagRef, updatedBagsData[bagId]!);
                    }

                    // Step 4: Create the order
                    String returnId =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Map<String, dynamic> orderMap = {
                      "id": returnId,
                      "bags": cart.entries
                          .map((entry) {
                            return entry.value.entries.map((colorEntry) {
                              return {
                                "bagId": entry.key,
                                "color": colorEntry.key,
                                "quantity": colorEntry.value,
                              };
                            }).toList();
                          })
                          .expand((x) => x)
                          .toList(),
                      "garment": garment,
                      "totalItems": getTotalQuantity(),
                      "createdAt": DateTime.now().toIso8601String(),
                    };

                    final orderRef =
                        firestore.collection('Buyings').doc(returnId);

                    transaction.set(orderRef, orderMap);
                  }).then((_) {
                    CustomToast.show(
                      'Bags added successfully',
                    );

                    setState(() {
                      cart.clear();
                    });
                  }).catchError((error) {
                    CustomToast.show(
                      'Error: $error',
                      bgColor: Colors.red,
                    );
                  });
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                text: 'Add Bags',
              ),
          ],
        ),
      ),
    );
  }
}
