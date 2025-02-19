import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/Models/buying_model.dart';
import 'package:nummlk/Models/order_model.dart';
import 'package:nummlk/Models/return_model.dart';
import 'package:nummlk/Models/user_model.dart';
import 'package:nummlk/service/database.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final DatabaseMethods databaseMethods;

  ItemBloc(this.databaseMethods) : super(const ItemState()) {
    on<GetAllItems>(_onGetAllItems);
    on<GetItemById>(_onGetItemById);
    on<SearchItems>(_onSearchItems);
    on<SortByGarment>(_onSortByGarment);
    on<GetOrderById>(_onGetOrderById);
    on<GetAllOrders>(_onGetAllOrders);
    on<GetAllUsers>(_onGetAllUsers);
    on<GetUserById>(_onGetUserById);
    on<GetReturnById>(_onGetReturnById);
    on<GetAllReturns>(_onGetAllReturns);
    on<GetAllBuyings>(_onGetAllBuyings);
  }

  FutureOr<void> _onGetAllItems(
      GetAllItems event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getAllItems();

      await for (final querySnapshot in query) {
        final bags = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Bag.fromMap(data);
        }).toList();

        emit(state.copyWith(isLoading: false, bags: bags, allBags: bags));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetItemById(
      GetItemById event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getItemById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final bag = Bag.fromMap(data!);
        emit(state.copyWith(isLoading: false, bag: bag));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onSearchItems(
      SearchItems event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      // final query = databaseMethods.getAllItems();

      // await for (final querySnapshot in query) {
      //   final bags = querySnapshot.docs.map((doc) {
      //     final data = doc.data() as Map<String, dynamic>;
      //     return Bag.fromMap(data);
      //   }).toList();

      final bags = state.allBags;

      final filteredBags = bags.where((bag) {
        return bag.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(state.copyWith(isLoading: false, bags: filteredBags));
      // }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onSortByGarment(
      SortByGarment event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      if (event.garment == 'All') {
        add(const GetAllItems());
      } else {
        final query = databaseMethods.getItemsByGarment(event.garment);

        await for (final querySnapshot in query) {
          final bags = querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Bag.fromMap(data);
          }).toList();

          emit(state.copyWith(isLoading: false, bags: bags));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetOrderById(
      GetOrderById event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getOrderById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final order = BagOrder.fromMap(data!);
        emit(state.copyWith(isLoading: false, order: order));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetAllOrders(
      GetAllOrders event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getAllOrders();

      await for (final querySnapshot in query) {
        final orders = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return BagOrder.fromMap(data);
        }).toList();

        emit(state.copyWith(
            isLoading: false, orders: orders, allOrders: orders));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetAllUsers(
      GetAllUsers event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getAllUsers();

      await for (final querySnapshot in query) {
        final users = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return User.fromMap(data);
        }).toList();

        emit(state.copyWith(isLoading: false, users: users));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetUserById(
      GetUserById event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getUserById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final user = User.fromMap(data!);
        emit(state.copyWith(isLoading: false, user: user));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetReturnById(
      GetReturnById event, Emitter<ItemState> emit) async {
    try {
      print('object');
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getReturnById(event.id);

      await for (final documentSnapshot in query) {
        final data = documentSnapshot.data();
        final returnn = Return.fromMap(data!);
        emit(state.copyWith(isLoading: false, returnn: returnn));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetAllReturns(
      GetAllReturns event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getAllReturns();

      await for (final querySnapshot in query) {
        final returns = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Return.fromMap(data);
        }).toList();

        emit(state.copyWith(isLoading: false, returnns: returns));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onGetAllBuyings(
      GetAllBuyings event, Emitter<ItemState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, isError: false, message: null));

      final query = databaseMethods.getAllBuyings();

      await for (final querySnapshot in query) {
        final buyings = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Buying.fromMap(data);
        }).toList();

        emit(state.copyWith(isLoading: false, buyings: buyings));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }
}
