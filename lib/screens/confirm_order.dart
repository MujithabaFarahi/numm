import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/Models/user_model.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/custom_card.dart';
import 'package:nummlk/widgets/custom_dropdown.dart';
import 'package:nummlk/widgets/custom_toast.dart';
import 'package:nummlk/widgets/primary_button.dart';

class ConfirmOrder extends StatefulWidget {
  final Map<String, Map<String, int>> cart;

  const ConfirmOrder({
    this.cart = const {},
    super.key,
  });

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  List<Bag> bags = [];
  List<User> users = [];
  List<User> selectedUsers = [];
  bool isDaraz = true;
  String? selectedUserId;
  String? selectedUserName;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final itemBloc = BlocProvider.of<ItemBloc>(context);

    bags = itemBloc.state.bags;
    users = itemBloc.state.users;
  }

  int getTotalQuantity() {
    int total = 0;
    for (var bag in widget.cart.values) {
      for (var qty in bag.values) {
        total += qty;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Confirm Order',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                children: widget.cart.entries.map((entry) {
                  final bagId = entry.key;
                  final bagName =
                      bags.firstWhere((bag) => bag.id == bagId).name;
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
                            'Bag: $bagName',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...colorsAndQuantities.entries.map(
                            (colorEntry) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      checkColor: ColorPalette.white,
                      activeColor: ColorPalette.primaryBlue,
                      value: isDaraz,
                      onChanged: (daraz) {
                        setState(() {
                          isDaraz = daraz!;
                        });
                        if (!isDaraz) {
                          setState(() {
                            selectedUserId = null;
                            selectedUserName = null;
                          });
                        }
                      },
                    ),
                    const Text('Daraz Order'),
                  ],
                ),
                if (!isDaraz) const SizedBox(height: 4),
                if (!isDaraz)
                  CustomDropdown(
                    hintText: 'Select Order Dealer',
                    labelText: 'Order Dealer',
                    value: selectedUserName,
                    options: users.map((user) => user.name).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUserName = value;
                        selectedUserId =
                            users.firstWhere((user) => user.name == value).id;
                      });
                    },
                  ),
                const SizedBox(height: 12),
                const Text('Packed By:'),
                const SizedBox(height: 6),
                SizedBox(
                  height: 195,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isSelected = selectedUsers.contains(user);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: CustomCard(
                          title: user.name,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedUsers.remove(user);
                              } else {
                                selectedUsers.add(user);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              isLoading: isLoading,
              onPressed: () async {
                if (selectedUsers.isEmpty) {
                  CustomToast.show(
                    'Please Select at least 1 packager',
                    bgColor: ColorPalette.negativeColor[500]!,
                  );
                  return;
                }

                if (!isDaraz && selectedUserId == null) {
                  CustomToast.show(
                    'Please Select order Dealer',
                    bgColor: ColorPalette.negativeColor[500]!,
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                FirebaseFirestore firestore = FirebaseFirestore.instance;

                await firestore.runTransaction((transaction) async {
                  // Step 1: Read all necessary data
                  Map<String, Map<String, dynamic>> bagsData = {};
                  for (String bagId in widget.cart.keys) {
                    final bagRef = firestore.collection('Bags').doc(bagId);
                    final bagSnapshot = await transaction.get(bagRef);

                    if (!bagSnapshot.exists) {
                      throw Exception('Bag does not exist');
                    }

                    bagsData[bagId] =
                        bagSnapshot.data() as Map<String, dynamic>;
                  }

                  // Read user data for the selected user if applicable
                  Map<String, dynamic>? selectedUserData;
                  if (selectedUserId != null) {
                    final userRef =
                        firestore.collection('Users').doc(selectedUserId);
                    final userSnapshot = await transaction.get(userRef);

                    if (!userSnapshot.exists) {
                      throw Exception('Selected user does not exist');
                    }

                    selectedUserData = userSnapshot.data();
                  }

                  // Read user data for selected packagers
                  Map<String, Map<String, dynamic>> packagersData = {};
                  for (var user in selectedUsers) {
                    final userRef = firestore.collection('Users').doc(user.id);
                    final userSnapshot = await transaction.get(userRef);

                    if (userSnapshot.exists) {
                      packagersData[user.id] = userSnapshot.data()!;
                    }
                  }

                  // Step 2: Process bag data
                  Map<String, Map<String, dynamic>> updatedBagsData = {};
                  for (String bagId in widget.cart.keys) {
                    Map<String, dynamic> bagData = bagsData[bagId]!;
                    List<String> colors = List<String>.from(bagData['colors']);
                    List<int> quantities = List<int>.from(bagData['quantity']);
                    List<int> quantitySold =
                        List<int>.from(bagData['quantitySold']);

                    int totalQuantitySold = bagData['totalQuantitySold'];

                    for (var entry in widget.cart[bagId]!.entries) {
                      String color = entry.key;
                      int orderQuantity = entry.value;
                      int colorIndex = colors.indexOf(color);

                      if (colorIndex == -1) {
                        throw Exception('Color not found in bag');
                      }

                      if (quantities[colorIndex] < orderQuantity) {
                        throw Exception('Insufficient stock for $color');
                      }

                      quantities[colorIndex] -= orderQuantity;
                      quantitySold[colorIndex] += orderQuantity;
                      totalQuantitySold += orderQuantity;
                    }

                    updatedBagsData[bagId] = {
                      "quantity": quantities,
                      "totalQuantitySold": totalQuantitySold,
                      "quantitySold": quantitySold,
                    };
                  }

                  // Step 3: Perform writes for bags
                  for (String bagId in updatedBagsData.keys) {
                    final bagRef = firestore.collection('Bags').doc(bagId);
                    transaction.update(bagRef, updatedBagsData[bagId]!);
                  }

                  // Step 4: Update order count for the selected user
                  if (selectedUserId != null) {
                    int orderCount = selectedUserData!['orderCount'] ?? 0;
                    transaction.update(
                      firestore.collection('Users').doc(selectedUserId),
                      {"orderCount": orderCount + getTotalQuantity()},
                    );
                  }

                  // Step 5: Update itemsProcessed for each selected packager
                  double itemCount = double.parse(
                    (getTotalQuantity() / selectedUsers.length)
                        .toStringAsFixed(2),
                  );

                  for (var user in selectedUsers) {
                    double itemsProcessed =
                        packagersData[user.id]?['itemsProcessed']?.toDouble() ??
                            0;

                    transaction.update(
                      firestore.collection('Users').doc(user.id),
                      {"itemsProcessed": itemsProcessed + itemCount},
                    );
                  }

                  // Step 6: Create the order
                  String orderId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Map<String, dynamic> orderMap = {
                    "orderId": orderId,
                    "bags": widget.cart.entries
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
                    "totalItems": getTotalQuantity(),
                    "createdAt": DateTime.now().toIso8601String(),
                    "darazOrder": isDaraz,
                    "orderDealer": selectedUserName,
                    "packagers": selectedUsers.map((user) {
                      return {
                        "name": user.name,
                        "itemsProcessed": itemCount,
                      };
                    })
                  };

                  final orderRef = firestore.collection('Orders').doc(orderId);
                  transaction.set(orderRef, orderMap);

                  setState(() {
                    isLoading = false;
                  });
                }).then((_) {
                  CustomToast.show(
                    'Order added successfully',
                    duration: 2,
                  );
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/add',
                      (route) => false,
                    );
                  }
                }).catchError((error) {
                  CustomToast.show(
                    'Error: $error',
                    bgColor: ColorPalette.negativeColor[400]!,
                  );
                });
              },
              text: 'Add Order',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
