import 'dart:ui';

import 'package:mvvm_template/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(Constants.prefKeyLanguage);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String? currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      // Set english
      _sharedPreferences.setString(
        Constants.prefKeyLanguage,
        LanguageType.english.getValue(),
      );
    } else {
      // Set arabic
      _sharedPreferences.setString(
        Constants.prefKeyLanguage,
        LanguageType.arabic.getValue(),
      ); 
    }
  }

  Future<Locale> getLocal() async {
    String? currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      return Constants.arLocal;
    } else {
      return Constants.enLocal;
    }
  }

  // Onboarding
  Future<void> setOnBoardingViewed({
    bool value = true,
  }) async {
    await _sharedPreferences.setBool(
        Constants.preferencesKeyIsOnBoardingViewed, value);
  }

  Future<bool> isOnboardingViewed() async {
    return _sharedPreferences
            .getBool(Constants.preferencesKeyIsOnBoardingViewed) ??
        false;
  }

  // Login
  Future<void> setUserLoggedIn({
    bool value = true,
  }) async {
    await _sharedPreferences.setBool(
        Constants.preferencesKeyIsUserLoggedIn, value);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(Constants.preferencesKeyIsUserLoggedIn) ??
        false;
  }

  Future<void> logout() {
    return _sharedPreferences.remove(Constants.preferencesKeyIsUserLoggedIn);
  }
}
