part of 'item_bloc.dart';

class ItemState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String? message;
  final List<Bag> bags;
  final Bag? bag;

  const ItemState({
    this.isLoading = false,
    this.isError = false,
    this.message,
    this.bags = const [],
    this.bag,
  });

  ItemState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    List<Bag>? bags,
    Bag? bag,
  }) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      bags: bags ?? this.bags,
      bag: bag ?? this.bag,
    );
  }

  @override
  List<Object?> get props => [
        message,
        isLoading,
        isError,
        bags,
        bag,
      ];
}
