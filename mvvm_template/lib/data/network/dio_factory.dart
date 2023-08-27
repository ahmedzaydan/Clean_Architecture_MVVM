import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();

    Map<String, String> headers = {
      Constants.contentType: Constants.applicationJson,
      Constants.accept: Constants.applicationJson,
      Constants.authorization: Constants.token,
      Constants.defaultLanguage:
          language, // todo get language from shared preferences
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: const Duration(milliseconds: Constants.apiTimeout),
      connectTimeout: const Duration(milliseconds: Constants.apiTimeout),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}
