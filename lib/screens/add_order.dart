import 'package:flutter/material.dart';
import 'package:nummlk/service/database.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/custom_dropdown.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  Stream<QuerySnapshot>? bagStream;
  String? selectedBagId;
  String? selectedBagName;
  List<String> bagColors = [];
  String? selectedColor;
  int quantity = 0;
  int maxQuantity = 100;

  final Map<String, Map<String, int>> cart = {};

  @override
  void initState() {
    super.initState();
    bagStream = DatabaseMethods().getAllItems();
  }

  void _addToCart() {
    if (selectedBagId == null || selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bag and a color')),
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bag added to order')),
    );
  }

  String getTotalQuantity() {
    int total = 0;
    for (var bag in cart.values) {
      for (var qty in bag.values) {
        total += qty;
      }
    }
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Order',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: bagStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text("Error fetching bags."));
                }

                final docs = snapshot.data!.docs;

                return Column(
                  children: [
                    CustomDropdown(
                      hintText: 'Select Bag',
                      labelText: 'Bag',
                      value: selectedBagId,
                      options:
                          docs.map((doc) => doc['name'] as String).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBagId = value;
                          selectedBagName =
                              value; // Update selectedBagName directly
                          bagColors = List<String>.from(docs.firstWhere(
                              (doc) => doc['id'] == selectedBagId)['colors']);
                          selectedColor = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            if (bagColors.isNotEmpty)
              CustomDropdown(
                hintText: 'Select Color',
                labelText: 'Color',
                value: selectedColor,
                options: bagColors,
                onChanged: (value) {
                  setState(() {
                    selectedColor = value;
                  });
                },
              ),
            if (selectedColor != null)
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
                      if (quantity > maxQuantity) {
                        setState(() {
                          quantity++;
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            PrimaryButton(
              onPressed: _addToCart,
              text: 'Add Bag',
            ),
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
                              selectedBagName; // Use selectedBagName
                          final colorsAndQuantities = entry.value;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bag: $bagId ($bagName)', // Display bag name
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
                      int quantitySold = bagData['quantitySold'] ?? 0;

                      for (var entry in cart[bagId]!.entries) {
                        String color = entry.key;
                        int orderQuantity = entry.value;

                        int colorIndex = colors.indexOf(color);
                        if (colorIndex == -1) {
                          throw Exception('Color not found in bag');
                        }

                        if (quantities[colorIndex] < orderQuantity) {
                          throw Exception('Insufficient stock for $color');
                        }

                        // Deduct quantity and update sold count
                        quantities[colorIndex] -= orderQuantity;
                        quantitySold += orderQuantity;
                      }

                      updatedBagsData[bagId] = {
                        "quantity": quantities,
                        "quantitySold": quantitySold,
                      };
                    }

                    // Step 3: Perform all writes after processing
                    for (String bagId in updatedBagsData.keys) {
                      final bagRef = firestore.collection('Bags').doc(bagId);
                      transaction.update(bagRef, updatedBagsData[bagId]!);
                    }

                    // Step 4: Create the order
                    String orderId =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Map<String, dynamic> orderMap = {
                      "orderId": orderId,
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
                      "status": "Pending",
                      "createdAt": DateTime.now().toIso8601String(),
                    };

                    final orderRef =
                        firestore.collection('Orders').doc(orderId);
                    transaction.set(orderRef, orderMap);
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order placed successfully'),
                      ),
                    );
                    setState(() {
                      cart.clear();
                    });
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    );
                  });
                },
                text: 'Place Order',
              ),
          ],
        ),
      ),
    );
  }
}
