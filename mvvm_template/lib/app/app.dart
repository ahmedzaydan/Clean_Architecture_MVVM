import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/app/constants.dart';
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
  final AppPreferences _appPreferences = Constants.instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => context.setLocale(local));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
