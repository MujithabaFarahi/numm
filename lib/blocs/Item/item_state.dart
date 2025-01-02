part of 'item_bloc.dart';

class ItemState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String? message;
  final List<Bag> bags;
  final Bag? bag;
  final BagOrder? order;
  final List<BagOrder> orders;
  final User? user;
  final List<User> users;

  const ItemState({
    this.isLoading = false,
    this.isError = false,
    this.message,
    this.bags = const [],
    this.bag,
    this.order,
    this.orders = const [],
    this.user,
    this.users = const [],
  });

  ItemState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    List<Bag>? bags,
    Bag? bag,
    BagOrder? order,
    List<BagOrder>? orders,
    User? user,
    List<User>? users,
  }) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      bags: bags ?? this.bags,
      bag: bag ?? this.bag,
      order: order ?? this.order,
      orders: orders ?? this.orders,
      user: user ?? this.user,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [
        message,
        isLoading,
        isError,
        bags,
        bag,
        order,
        orders,
        user,
        users,
      ];
}
