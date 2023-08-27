import 'package:mvvm_template/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? lang =
        _sharedPreferences.getString(Constants.preferencesKeyLanguage);

    if (lang != null && lang.isNotEmpty) {
      return lang;
    } else {
      return LanguageType.ENGLISH.getValue();
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
}
