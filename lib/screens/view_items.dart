import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nummlk/service/database.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/bag_card.dart';
import 'package:nummlk/widgets/custom_dropdown.dart';

class ViewItems extends StatefulWidget {
  const ViewItems({super.key});

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  String _selectedGarment = 'All';
  final List<String> _dropdownOptions = ['All', 'Lulu', 'Naleem', 'Akram'];

  Stream<QuerySnapshot>? bagStream;

  @override
  void initState() {
    _getAllItems();
    super.initState();
  }

  void _getAllItems() {
    bagStream = DatabaseMethods().getAllItems();
    setState(() {});
  }

  void _filterItemsByGarment(String? garment) {
    if (garment != 'All') {
      bagStream = DatabaseMethods().getItemsByGarment(garment!);
    } else {
      _getAllItems();
    }
    setState(() {});
  }

  Widget allBagDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: bagStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                  quantitySold: 0,
                );
              });
        }

        if (snapshot.hasError) {
          return const Center(child: Text("An error occurred."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No bags found."));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            String id = ds["id"] ?? "Unknown";
            String name = ds["name"] ?? "Unknown";
            String garment = ds["garment"] ?? "Unknown";
            int quantitySold = ds["quantitySold"] ?? 0;
            List<String> colors = List<String>.from(ds["colors"] ?? []);
            List<int> quantities = List<int>.from(ds["quantity"] ?? []);

            return BagCard(
              id: id,
              name: name,
              garment: garment,
              colors: colors,
              quantities: quantities,
              quantitySold: quantitySold,
            );
          },
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              width: 110,
              height: 50,
              hintText: 'Select Garment to Sort',
              borderColor: Colors.transparent,
              value: _selectedGarment,
              options: _dropdownOptions,
              onChanged: (newValue) {
                setState(() {
                  _selectedGarment = newValue;
                  _filterItemsByGarment(newValue);
                });
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: allBagDetails(),
            ),
          ],
        ),
      ),
    );
  }
}
