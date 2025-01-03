part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();
}

final class GetAllItems extends ItemEvent {
  const GetAllItems();

  @override
  List<Object?> get props => [];
}

final class GetItemById extends ItemEvent {
  final String id;

  const GetItemById(this.id);

  @override
  List<Object?> get props => [id];
}

final class SearchItems extends ItemEvent {
  final String query;

  const SearchItems(
    this.query,
  );

  @override
  List<Object?> get props => [query];
}

final class SortByGarment extends ItemEvent {
  final String garment;
  const SortByGarment(
    this.garment,
  );

  @override
  List<Object?> get props => [garment];
}

final class GetAllOrders extends ItemEvent {
  const GetAllOrders();

  @override
  List<Object?> get props => [];
}

final class GetOrderById extends ItemEvent {
  final String id;

  const GetOrderById(this.id);

  @override
  List<Object?> get props => [id];
}

final class GetAllUsers extends ItemEvent {
  const GetAllUsers();

  @override
  List<Object?> get props => [];
}

final class GetUserById extends ItemEvent {
  final String id;

  const GetUserById(this.id);

  @override
  List<Object?> get props => [id];
}

final class GetAllReturns extends ItemEvent {
  const GetAllReturns();

  @override
  List<Object?> get props => [];
}

final class GetAllBuyings extends ItemEvent {
  const GetAllBuyings();

  @override
  List<Object?> get props => [];
}

final class GetBuyingById extends ItemEvent {
  final String id;

  const GetBuyingById(this.id);

  @override
  List<Object?> get props => [id];
}
