import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/presentation/resources/assets_manager.dart';
import 'package:mvvm_template/presentation/resources/color_manager.dart';
import 'package:mvvm_template/presentation/resources/constants_manager.dart';
import 'package:mvvm_template/presentation/resources/routes_manager.dart';

import '../../app/constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = Constants.instance<AppPreferences>();

  void _startDelay() {
    _timer = Timer(
      const Duration(
        seconds: AppConstants.splashDelay,
      ),
      _goNext,
    );
  }

  Future<void> _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) {
      if (isUserLoggedIn) {
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      } else {
        _appPreferences.isOnboardingViewed().then((isOnBoardingViewed) {
          if (isOnBoardingViewed) {
            // Navigate to login screen
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          } else {
            // Navigate to on boarding screen
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(
            ImageAssets.splashLogo,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
