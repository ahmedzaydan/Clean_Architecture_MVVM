import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mvvm_template/app/app.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Constants.arLocal,
        Constants.enLocal,
      ],
      path: Constants.assetsPathLocalization,
      child: Phoenix(child: MyApp()),
    ),
  );
}
