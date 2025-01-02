import 'package:flutter/material.dart';
import 'package:nummlk/screens/add_bag.dart';
import 'package:nummlk/screens/add_item.dart';
import 'package:nummlk/screens/add_return.dart';
import 'package:nummlk/screens/confirm_order.dart';
import 'package:nummlk/screens/layout_screen.dart';
import 'package:nummlk/screens/login_screen.dart';
import 'package:nummlk/screens/splash_screen.dart';
import 'package:nummlk/screens/update_item.dart';
import 'package:nummlk/screens/view_item.dart';
import 'package:nummlk/screens/view_order.dart';
import 'package:nummlk/screens/view_orders.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/addBag':
        return _createRoute(
          const AddBag(),
        );

      case '/viewOrder':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          ViewOrder(
            orderId: args?['orderId'],
          ),
        );

      case '/confirm':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          ConfirmOrder(
            cart: args?['cart'],
          ),
        );

      case '/orders':
        return _createRoute(
          const ViewOrders(),
        );

      case '/addreturn':
        return _createRoute(
          const AddReturn(),
        );

      case '/viewItem':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          ViewItem(
            bagId: args?['bagId'],
            title: args?['title'],
          ),
        );

      case '/updateItem':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          UpdateItem(
            id: args?['id'],
          ),
        );

      case '/login':
        return _createRoute(
          const LoginScreen(),
        );

      case '/additem':
        return _createRoute(
          const AddItem(),
        );

      case '/home':
        return _createRoute(
          const LayoutScreen(
            pageIndex: 0,
          ),
        );

      case '/item':
        return _createRoute(
          const LayoutScreen(
            pageIndex: 1,
          ),
        );

      case '/add':
        return _createRoute(
          const LayoutScreen(
            pageIndex: 2,
          ),
        );

      case '/more':
        return _createRoute(
          const LayoutScreen(
            pageIndex: 3,
          ),
        );

      default:
        return _createRoute(
          const SplashScreen(),
        );
    }
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.2, 0.0); // Slide from the right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final slideTween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(slideTween);

      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      final fadeAnimation = animation.drive(fadeTween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}
