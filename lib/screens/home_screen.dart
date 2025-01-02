import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    itemBloc.add(const GetAllUsers());
    itemBloc.add(const GetAllItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: PrimaryButton(
                text: 'Log Out',
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
