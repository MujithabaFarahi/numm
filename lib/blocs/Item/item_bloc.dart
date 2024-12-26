import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nummlk/Models/bag_model.dart';
import 'package:nummlk/service/database.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final DatabaseMethods databaseMethods;

  ItemBloc(this.databaseMethods) : super(const ItemState()) {
    on<GetAllItems>(_onGetAllItems);
    on<SearchItems>(_onSearchItems);
    on<SortByGarment>(_onSortByGarment);
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

        emit(state.copyWith(isLoading: false, bags: bags));
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

      final query = databaseMethods.getAllItems();

      await for (final querySnapshot in query) {
        final bags = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Bag.fromMap(data);
        }).toList();

        final filteredBags = bags.where((bag) {
          return bag.name.toLowerCase().contains(event.query.toLowerCase());
        }).toList();

        emit(state.copyWith(isLoading: false, bags: filteredBags));
      }
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
}
