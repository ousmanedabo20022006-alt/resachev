import 'package:flutter/material.dart';

import 'screens/affichage.dart';
import 'utils/theme_controller.dart';
import 'services/api/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.load();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = ThemeController();

  @override
  void initState() {
    super.initState();

    themeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: themeController.themeMode,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.orange.shade50,
          indicatorColor: Colors.orange,
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: Colors.black),
          ),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),

      home: Affichage(
        themeController: themeController,
      ),
    );
  }
}