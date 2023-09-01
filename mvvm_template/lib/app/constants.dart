import 'dart:ui';

import 'package:get_it/get_it.dart';

class Constants {
  static final instance = GetIt.instance;

  static const int zero = 0;
  static const int apiTimeout = 60 * 1000; // Milliseconds
  static const int usernameLength = 8;
  static const int passwordLength = 6;
  static const int phoneNumberLength = 9;
  static const int cacheHomeDataInterval = 60 * 1000; // Milliseconds
  static const int storeDetailsInterval = 60 * 1000; // Milliseconds

  static Function emptyFunction = () {};

  static const String baseUrl = "https://ahmedzaydan.wiremockapi.cloud/";
  static const String loginEndpoint = "/customers/login";
  static const String forgotPasswordEndpoint = "/customers/forgot-password";
  static const String registerEndpoint = "/customers/register";
  static const String homeEndpoint = "/home";
  static const String storeDetailsEndpoint = "/storeDetails";
  static const String token = "Send token here";
  static const String applicationJson = 'application/json';
  static const String contentType = 'content-type';
  static const String accept = 'accept';
  static const String authorization = 'authorization';
  static const String defaultLanguage = 'language';
  static const String prefKeyLanguage = 'language';
  static const String preferencesKeyIsUserLoggedIn = 'isUserLoggedIn';
  static const String preferencesKeyIsOnBoardingViewed = 'isOnBoardingViewed';
  static const String cacheHomeDataKey = 'homeData';
  static const String storeDetailsDataKey = 'storeDetailsData';
  // Language manager
  static const String english = 'en';
  static const String arabic = 'ar';
  static const String assetsPathLocalization = 'assets/translations';

  static const Locale arLocal = Locale("ar", "SA");
  static const Locale enLocal = Locale("en", "US");
}
