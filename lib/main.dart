import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nummlk/firebase_options.dart';
import 'package:nummlk/routes.dart';
import 'package:nummlk/screens/splash_screen.dart';
import 'package:nummlk/theme/color_pallette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUMM.LK',
      theme: ThemeData(
        fontFamily: 'Outfit',
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: ColorPalette.primaryTextColor,
          primary: Color.fromARGB(255, 18, 39, 144),
          onPrimary: Colors.white,
          // secondary: Colors.white,
          // onSecondary: Color.fromARGB(255, 56, 88, 255),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
          },
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
