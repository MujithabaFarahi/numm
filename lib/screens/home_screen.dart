import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/widgets/appbar.dart';
import 'package:nummlk/widgets/user_box.dart';

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
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.users.isEmpty) {
            return Center(
              child: Text(
                state.message ?? 'No users available.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Space between columns
                mainAxisSpacing: 16, // Space between rows
                childAspectRatio: 3 / 2, // Aspect ratio of each item
              ),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserBox(
                  name: user.name,
                  id: user.id,
                  itemsProcessed: user.itemsProcessed,
                  orderDeals: user.orderCount,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
