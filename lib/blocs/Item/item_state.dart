part of 'item_bloc.dart';

class ItemState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String? message;
  final List<Bag> bags;
  final List<Bag> allBags;
  final Bag? bag;
  final BagOrder? order;
  final List<BagOrder> orders;
  final List<BagOrder> allOrders;
  final User? user;
  final List<User> users;
  final Return? returnn;
  final List<Return> returnns;
  final Buying? buying;
  final List<Buying> buyings;

  const ItemState({
    this.isLoading = false,
    this.isError = false,
    this.message,
    this.bags = const [],
    this.allBags = const [],
    this.bag,
    this.order,
    this.orders = const [],
    this.allOrders = const [],
    this.user,
    this.users = const [],
    this.returnn,
    this.returnns = const [],
    this.buying,
    this.buyings = const [],
  });

  ItemState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    List<Bag>? bags,
    List<Bag>? allBags,
    Bag? bag,
    BagOrder? order,
    List<BagOrder>? orders,
    List<BagOrder>? allOrders,
    User? user,
    List<User>? users,
    Return? returnn,
    List<Return>? returnns,
    Buying? buying,
    List<Buying>? buyings,
  }) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      bags: bags ?? this.bags,
      allBags: allBags ?? this.allBags,
      bag: bag ?? this.bag,
      order: order ?? this.order,
      orders: orders ?? this.orders,
      allOrders: allOrders ?? this.allOrders,
      user: user ?? this.user,
      users: users ?? this.users,
      returnn: returnn ?? this.returnn,
      returnns: returnns ?? this.returnns,
      buying: buying ?? this.buying,
      buyings: buyings ?? this.buyings,
    );
  }

  @override
  List<Object?> get props => [
        message,
        isLoading,
        isError,
        bags,
        allBags,
        bag,
        order,
        orders,
        allOrders,
        user,
        users,
        returnn,
        returnns,
        buying,
        buyings,
      ];
}
