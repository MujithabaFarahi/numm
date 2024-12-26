part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();
}

final class GetAllItems extends ItemEvent {
  const GetAllItems();

  @override
  List<Object?> get props => [];
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
