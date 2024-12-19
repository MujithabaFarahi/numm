import 'package:flutter/material.dart';
import 'package:nummlk/service/database.dart';
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
  final List<String> _dropdownOptions = ['Lulu', 'Naleem', 'Akram'];
  final List<String> _availableColors = [];

  late TextEditingController _colorController;
  late TextEditingController _bagController;

  @override
  void initState() {
    super.initState();
    _colorController = TextEditingController();
    _bagController = TextEditingController();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _bagController.dispose();
    super.dispose();
  }

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
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryTextfield(
                              hintText: "Enter Color",
                              labelText: "Color",
                              controller: _colorController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          PrimaryButton(
                            text: "Add",
                            onPressed: () {
                              final newColor = _colorController.text.trim();

                              if (newColor.isNotEmpty) {
                                if (!_availableColors.contains(newColor)) {
                                  setState(() {
                                    _availableColors.add(newColor);
                                    _colorController.clear();
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('$newColor is already added'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a color'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            width: 80,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_availableColors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _availableColors
                              .map(
                                (color) => Dismissible(
                                  key: Key(color),
                                  direction: DismissDirection.horizontal,
                                  onDismissed: (direction) {
                                    setState(() {
                                      _availableColors.remove(color);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$color removed'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  background: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Text(
                                            color,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                  PrimaryButton(
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

                      String id = const Uuid().v4();

                      Map<String, dynamic> bagInfoMap = {
                        "id": id,
                        "name": _bagController.text,
                        "garment": _selectedGarment,
                        "colors": _availableColors,
                        "quantitySold": 0,
                        "createdAt": DateTime.now().toIso8601String(),
                      };

                      await DatabaseMethods()
                          .addItem(bagInfoMap, id)
                          .then((value) {
                        CustomToast.show(
                          "Bag Details added successfully",
                          bgColor: Colors.green,
                          textColor: Colors.white,
                        );

                        _bagController.clear();
                        setState(() {
                          _selectedGarment = null;
                          _availableColors.clear();
                        });
                      });
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
