import 'package:flutter/material.dart';
import 'package:mvvm_template/app/app.dart';
import 'package:mvvm_template/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}
