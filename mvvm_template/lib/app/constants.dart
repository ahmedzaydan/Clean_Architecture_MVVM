import 'package:get_it/get_it.dart';

class Constants {
  static final instance = GetIt.instance;
  static const int zero = 0;
  static const int apiTimeout = 60 * 1000; // Milliseconds
  static Function emptyFunction = () {};
  static const String baseUrl = "https://ahmedzaydan.wiremockapi.cloud/";
  static const String loginEndpoint = "/customers/login";
  static const String forgotPasswordEndpoint = "/customers/forgot-password";
  static const String token = "Send token here";
  static const String applicationJson = 'application/json';
  static const String contentType = 'content-type';
  static const String accept = 'accept';
  static const String authorization = 'authorization';
  static const String defaultLanguage = 'language';
  static const String preferencesKeyLanguage = 'language';
  static const String preferencesKeyIsUserLoggedIn = 'isUserLoggedIn';
  static const String preferencesKeyIsOnBoardingViewed = 'isOnBoardingViewed';
}
