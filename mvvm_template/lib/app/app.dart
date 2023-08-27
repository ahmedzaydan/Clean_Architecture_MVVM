import 'package:flutter/material.dart';
import 'package:mvvm_template/presentation/resources/routes_manager.dart';
import 'package:mvvm_template/presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  // Named constructor
  const MyApp._internal();

  // Singleton or single instance
  static const _instance = MyApp._internal();

  // Factory constructor
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
