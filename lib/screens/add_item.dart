import 'package:flutter/material.dart';
import 'package:nummlk/service/database.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/custom_dropdown.dart';
import 'package:nummlk/widgets/custom_toast.dart';
import 'package:nummlk/widgets/primary_button.dart';
import 'package:nummlk/widgets/primary_textfield.dart';
import 'package:uuid/uuid.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? _selectedGarment;
  // int quantity = 1;
  final List<String> _dropdownOptions = ['Lulu', 'Naleem', 'Akram'];
  final List<String> _availableColors = [];
  // final List<int?> _availableQuantity = [];
  int? selectedIndex;
  bool isLoading = false;

  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _bagController = TextEditingController();
  // final TextEditingController _quantityController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _quantityController.text = quantity.toString();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _bagController.dispose();
    // _quantityController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  // void _updateQuantity(int newQuantity) {
  //   if (newQuantity >= 1) {
  //     setState(() {
  //       quantity = newQuantity;
  //       _quantityController.text = newQuantity.toString();
  //     });
  //     _focusNode.unfocus();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Item',
        showBackButton: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextfield(
                        hintText: "Enter Bag Name",
                        labelText: "Bag",
                        controller: _bagController,
                      ),
                      const SizedBox(height: 20),
                      CustomDropdown(
                        hintText: 'Select Garment',
                        labelText: 'Garment',
                        value: _selectedGarment,
                        options: _dropdownOptions,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGarment = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      (selectedIndex != null)
                          ? const Column(
                              children: [
                                Text(
                                    'Enter Total Quantity For The Selected Color Below and tap Add'),
                                SizedBox(height: 10),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryTextfield(
                              hintText: "Enter Color",
                              labelText: "Color",
                              controller: _colorController,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // SizedBox(
                          //   child: Row(
                          //     children: [
                          //       IconButton(
                          //         onPressed: () {
                          //           if (quantity > 1) {
                          //             _updateQuantity(quantity - 1);
                          //           }
                          //         },
                          //         icon: const Icon(Icons.remove),
                          //       ),
                          //       SizedBox(
                          //         width: 60,
                          //         child: PrimaryTextfield(
                          //             focusNode: _focusNode,
                          //             textAlign: TextAlign.center,
                          //             keyboardType: TextInputType.number,
                          //             hintText: 'Quantity',
                          //             controller: _quantityController,
                          //             onChanged: (value) {
                          //               final int? newQuantity =
                          //                   int.tryParse(value);
                          //               if (newQuantity != null &&
                          //                   newQuantity >= 1) {
                          //                 quantity = newQuantity;
                          //               }
                          //             }),
                          //       ),
                          //       IconButton(
                          //         onPressed: () {
                          //           _updateQuantity(quantity + 1);
                          //         },
                          //         icon: const Icon(Icons.add),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: (selectedIndex != null)
                                  ? PrimaryButton(
                                      text: "Cancel",
                                      backgroundColor: Colors.white,
                                      foregroundColor: ColorPalette.primaryBlue,
                                      borderColor: ColorPalette.primaryBlue,
                                      onPressed: () {
                                        setState(() {
                                          selectedIndex = null;
                                        });
                                      })
                                  : Container()),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: PrimaryButton(
                              text: "Add",
                              onPressed: (selectedIndex != null)
                                  ? () {
                                      // _availableQuantity[selectedIndex!] =
                                      //     quantity;

                                      _availableColors[selectedIndex!] =
                                          _colorController.text;

                                      // _updateQuantity(1);
                                      _colorController.clear();
                                      setState(() {
                                        selectedIndex = null;
                                      });
                                    }
                                  : () {
                                      // final newQuantity = int.tryParse(
                                      //     _quantityController.text);

                                      // if (newQuantity == null ||
                                      //     newQuantity < 1) {
                                      //   CustomToast.show(
                                      //       "Please enter a positive quantity",
                                      //       bgColor: Colors.red);
                                      //   return;
                                      // }

                                      if (_colorController.text.isEmpty) {
                                        CustomToast.show("Please enter a color",
                                            bgColor: Colors.red);
                                        return;
                                      }

                                      final newColor = _colorController.text
                                              .trim()
                                              .split(' ')
                                              .map((word) => word.toLowerCase())
                                              .join('')
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          _colorController.text
                                              .trim()
                                              .split(' ')
                                              .map((word) => word.toLowerCase())
                                              .join('')
                                              .substring(1);

                                      if (newColor.isNotEmpty) {
                                        if (!_availableColors
                                            .contains(newColor)) {
                                          setState(() {
                                            _availableColors.add(newColor);
                                            // _availableQuantity.add(newQuantity);
                                            _colorController.clear();
                                            // _updateQuantity(1);
                                          });
                                        } else {
                                          CustomToast.show(
                                              '$newColor is already added',
                                              bgColor: Colors.red);
                                          return;
                                        }
                                      }
                                    },
                              width: 120,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_availableColors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _availableColors.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final color = entry.value;
                              // final quantity = _availableQuantity[index];

                              return Dismissible(
                                key: Key(color),
                                direction: DismissDirection.horizontal,
                                onDismissed: (direction) {
                                  setState(() {
                                    _availableColors.removeAt(index);
                                    // _availableQuantity.removeAt(index);
                                    selectedIndex = null;
                                  });
                                  CustomToast.show(
                                    '$color removed',
                                    bgColor: Colors.red,
                                  );
                                },
                                background: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Material(
                                    elevation: 1,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
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
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      _colorController.text =
                                          _availableColors[index];

                                      // _updateQuantity(
                                      //     _availableQuantity[index]!);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (selectedIndex == index)
                                              ? ColorPalette.positiveColor[300]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                color,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              // Text(
                                              //   quantity.toString(),
                                              //   style: const TextStyle(
                                              //     fontSize: 14,
                                              //     fontWeight: FontWeight.w500,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        )
                    ],
                  ),
                  PrimaryButton(
                    isLoading: isLoading,
                    onPressed: () async {
                      if (_bagController.text.isEmpty) {
                        CustomToast.show("Bag name cannot be empty",
                            bgColor: Colors.red);
                        return;
                      }

                      if (_selectedGarment == null ||
                          _selectedGarment!.isEmpty) {
                        CustomToast.show("Please select a garment",
                            bgColor: Colors.red);
                        return;
                      }

                      if (_availableColors.isEmpty) {
                        CustomToast.show("Please add at least one color",
                            bgColor: Colors.red);
                        return;
                      }

                      String bagName = _bagController.text
                          .trim()
                          .split(' ')
                          .map((word) => word.isNotEmpty
                              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                              : word)
                          .join(' ');

                      bool isUnique =
                          await DatabaseMethods().isNameUnique(bagName);

                      if (!isUnique) {
                        CustomToast.show("Name already exists",
                            bgColor: Colors.red);

                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      String id = const Uuid().v4();

                      Map<String, dynamic> bagInfoMap = {
                        "id": id,
                        "name": bagName,
                        "garment": _selectedGarment,
                        "colors": _availableColors,
                        "quantityBought": List.generate(
                            _availableColors.length, (index) => 0),
                        "quantity": List.generate(
                            _availableColors.length, (index) => 0),
                        "quantitySold": List.generate(
                            _availableColors.length, (index) => 0),
                        "totalQuantitySold": 0,
                        "createdAt": DateTime.now().toIso8601String(),
                        "lastUpdated": DateTime.now().toIso8601String(),
                      };

                      await DatabaseMethods()
                          .addItem(bagInfoMap, id)
                          .then((value) {
                        CustomToast.show(
                          "Bag Details added successfully",
                          bgColor: Colors.green,
                          textColor: Colors.white,
                        );
                      });

                      _bagController.clear();
                      setState(() {
                        _selectedGarment = null;
                        _availableColors.clear();
                        // _availableQuantity.clear();
                      });

                      setState(() {
                        isLoading = false;
                      });
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    text: 'Add Bag',
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
