import 'package:flutter/material.dart';
import 'package:nummlk/widgets/appbar.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Add Order',
      ),
      body: Center(
        child: Text('Add Order'),
      ),
    );
  }
}
