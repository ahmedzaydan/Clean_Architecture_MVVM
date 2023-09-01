import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/data/network/failure.dart';

import '../../presentation/resources/strings_manager.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.defaultDataSource.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.connectTimeout.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.sendTimeout.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.receiveTimeout.getFailure();
    case DioExceptionType.cancel:
      return DataSource.cancel.getFailure();
    case DioExceptionType.badResponse:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(
          statusCode: error.response?.statusCode ?? Constants.zero,
          message: error.response?.statusMessage ?? AppStrings.empty.tr(),
        );
      } else {
        return DataSource.defaultDataSource.getFailure();
      }
    default:
      return DataSource.defaultDataSource.getFailure();
  }
}

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultDataSource,
}

class ResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int forbidden = 403;
  static const int unAuthorized = 401;
  static const int notFound = 404;
  static const int internalServerError = 500;

  // Local status codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultResponseCode = -7;
}

class ResponseMessage {
  // Api status messages
  static const String success = AppStrings.success;
  static const String noContent = AppStrings.noContent;
  static const String badRequest = AppStrings.badRequestError;
  static const String forbidden = AppStrings.forbiddenError;
  static const String unAuthorized = AppStrings.unauthorizedError;
  static const String notFound = AppStrings.notFoundError;
  static const String internalServerError = AppStrings.internalServerError;

  // Local status messages
  static const String connectTimeout = AppStrings.timeoutError;
  static const String cancel = AppStrings.defaultError;
  static const String receiveTimeout = AppStrings.timeoutError;
  static const String sendTimeout = AppStrings.timeoutError;
  static const String cacheError = AppStrings.cacheError;
  static const String noInternetConnection = AppStrings.noInternetError;
  static const String defaultMessage = AppStrings.defaultError;
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
