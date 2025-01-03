import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nummlk/blocs/Item/item_bloc.dart';
import 'package:nummlk/theme/color_pallette.dart';
import 'package:nummlk/widgets/appbar.dart';

class ViewUser extends StatefulWidget {
  final String? userId;
  final bool? isUser;

  const ViewUser({
    this.userId,
    this.isUser = false,
    super.key,
  });

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  @override
  void initState() {
    super.initState();
    final itemBloc = BlocProvider.of<ItemBloc>(context);
    User? user = FirebaseAuth.instance.currentUser;

    if (widget.isUser != null && widget.isUser! && user != null) {
      itemBloc.add(GetUserById(user.uid));
    } else {
      itemBloc.add(GetUserById(widget.userId ?? 'a'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'User',
        showBackButton: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError || state.user == null) {
            return Center(
              child: Text(
                state.message ?? 'Failed to load user details.',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          final user = state.user!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(
                      fontSize: 16, color: ColorPalette.mainGray[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Role: ${user.role}',
                  style: TextStyle(
                      fontSize: 16, color: ColorPalette.mainGray[500]),
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items Processed: ${user.itemsProcessed}',
                      style: TextStyle(
                          fontSize: 16, color: ColorPalette.mainGray[500]),
                    ),
                    Text(
                      'Order Deals: ${user.orderDeals}',
                      style: TextStyle(
                          fontSize: 16, color: ColorPalette.mainGray[500]),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last Login: ${user.lastLogin.toString().split(' ')[0]} ${user.lastLogin.toString().split(' ')[1].split('.')[0]}',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.mainGray[500]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
