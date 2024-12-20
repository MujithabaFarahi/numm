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
  List<String> bagColors = [];
  String? selectedColor;
  int quantity = 1;

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
    });

    setState(() {
      selectedColor = null;
      quantity = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bag added to order')),
    );
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

                return CustomDropdown(
                  hintText: 'Select Bag',
                  labelText: 'Bag',
                  value: selectedBagId,
                  options: docs.map((doc) => doc['name'] as String).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBagId = value;
                      bagColors = List<String>.from(
                        docs.firstWhere(
                            (doc) => doc['name'] == value)['colors'],
                      );
                      selectedColor = null; // Reset selected color
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

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
                      setState(() {
                        quantity++;
                      });
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
                child: ListView(
                  children: cart.entries.map((entry) {
                    final bagId = entry.key;
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
                              'Bag : $bagId',
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

            // Place Order Button
            if (cart.isNotEmpty)
              PrimaryButton(
                onPressed: () async {
                  String orderId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Map<String, dynamic> orderMap = {
                    "orderId": orderId,
                    "bags": cart,
                    "status": "Pending",
                    "createdAt": DateTime.now().toIso8601String(),
                  };

                  await DatabaseMethods().addOrder(orderMap, orderId).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order placed successfully')),
                    );
                    setState(() {
                      cart.clear();
                    });
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
