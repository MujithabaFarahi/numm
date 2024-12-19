import 'package:flutter/material.dart';
import 'package:nummlk/screens/add_item.dart';
import 'package:nummlk/screens/layout_screen.dart';
import 'package:nummlk/screens/login_screen.dart';
import 'package:nummlk/screens/splash_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/additem':
        return MaterialPageRoute(
          builder: (_) => const AddItem(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const LayoutScreen(
            pageIndex: 0,
          ),
        );

      case '/item':
        return MaterialPageRoute(
          builder: (_) => const LayoutScreen(
            pageIndex: 1,
          ),
        );

      case '/add':
        return MaterialPageRoute(
          builder: (_) => const LayoutScreen(
            pageIndex: 2,
          ),
        );

      case '/view':
        return MaterialPageRoute(
          builder: (_) => const LayoutScreen(
            pageIndex: 3,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
