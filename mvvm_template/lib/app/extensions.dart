import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/data/data_source/local_data_source.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';

import '../data/network/error_handler.dart';
import '../data/network/failure.dart';
import '../presentation/common/state_renderer/state_renderer.dart';
import '../presentation/common/state_renderer/state_renderer_impl.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return AppStrings.empty.tr();
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(
          statusCode: ResponseCode.success,
          message: ResponseMessage.success.tr(),
        );
      case DataSource.noContent:
        return Failure(
          statusCode: ResponseCode.noContent,
          message: ResponseMessage.noContent.tr(),
        );
      case DataSource.badRequest:
        return Failure(
          statusCode: ResponseCode.badRequest,
          message: ResponseMessage.badRequest.tr(),
        );
      case DataSource.forbidden:
        return Failure(
          statusCode: ResponseCode.forbidden,
          message: ResponseMessage.forbidden.tr(),
        );
      case DataSource.unauthorized:
        return Failure(
          statusCode: ResponseCode.unAuthorized,
          message: ResponseMessage.unAuthorized.tr(),
        );
      case DataSource.notFound:
        return Failure(
          statusCode: ResponseCode.notFound,
          message: ResponseMessage.notFound.tr(),
        );
      case DataSource.internalServerError:
        return Failure(
          statusCode: ResponseCode.internalServerError,
          message: ResponseMessage.internalServerError.tr(),
        );
      case DataSource.connectTimeout:
        return Failure(
          statusCode: ResponseCode.connectTimeout,
          message: ResponseMessage.connectTimeout.tr(),
        );
      case DataSource.cancel:
        return Failure(
          statusCode: ResponseCode.cancel,
          message: ResponseMessage.cancel.tr(),
        );
      case DataSource.receiveTimeout:
        return Failure(
          statusCode: ResponseCode.receiveTimeout,
          message: ResponseMessage.receiveTimeout.tr(),
        );
      case DataSource.sendTimeout:
        return Failure(
          statusCode: ResponseCode.sendTimeout,
          message: ResponseMessage.sendTimeout.tr(),
        );
      case DataSource.cacheError:
        return Failure(
          statusCode: ResponseCode.cacheError,
          message: ResponseMessage.cacheError.tr(),
        );
      case DataSource.noInternetConnection:
        return Failure(
          statusCode: ResponseCode.noInternetConnection,
          message: ResponseMessage.noInternetConnection.tr(),
        );
      default:
        return Failure(
          statusCode: ResponseCode.defaultResponseCode,
          message: ResponseMessage.defaultMessage.tr(),
        );
    }
  }
}

extension FlowStateExtension on FlowState {
  // This function will called from view
  // and then we call StateRenderer class to return UI based on state type
  Widget getScreenWidget({
    required BuildContext context,
    // This is content ui of the screen,
    // that will be used in case of showing popup
    required Widget contentScreenWidget,
    required Function function,
  }) {
    switch (runtimeType) {
      case LoadingState:
        if (getStateRendererType() == StateRendererType.popupLoadingState) {
          // Show popup loading
          _showPopup(
            context: context,
            stateRendererType: getStateRendererType(),
            message: getMessage(),
          );

          return contentScreenWidget; // Show content ui of the screen
        } else {
          // Full screen loading state
          return _showFullScreen(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            function: Constants.emptyFunction,
          );
        }

      case ErrorState:
        _dismissDialog(context);
        if (getStateRendererType() == StateRendererType.popupErrorState) {
          // Show popup error
          _showPopup(
            context: context,
            stateRendererType: getStateRendererType(),
            message: getMessage(),
          );

          return contentScreenWidget; // Show content ui of the screen
        } else {
          // Full screen error state
          return _showFullScreen(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            function: function,
          );
        }

      case EmptyState:
        return _showFullScreen(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          function: Constants.emptyFunction,
        );

      case ContentState:
        _dismissDialog(context);
        return contentScreenWidget;

      case SuccessState:
        _dismissDialog(context);
        // Show popup success
        _showPopup(
          context: context,
          stateRendererType: getStateRendererType(),
          message: AppStrings.success.tr(),
        );
        return contentScreenWidget;
      default:
        _dismissDialog(context);
        return contentScreenWidget;
    }
  }

  void _showPopup({
    required BuildContext context,
    required StateRendererType stateRendererType,
    required String message,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (context) {
          return StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            function: Constants.emptyFunction,
          );
        },
      ),
    );
  }

  Widget _showFullScreen({
    required StateRendererType stateRendererType,
    required String message,
    required Function function,
  }) {
    return StateRenderer(
      stateRendererType: stateRendererType,
      message: message,
      function: function,
    );
  }

  bool _isCurrentDialogShowing(BuildContext context) {
    // If return true, it means that there is a dialog and need to pop it
    // If return false, it means that there is no dialog
    return ModalRoute.of(context)?.isCurrent != true;
  }

  void _dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  Widget showContentWidget(StateRendererType stateRendererType) {
    return StateRenderer(
        stateRendererType: stateRendererType,
        function: Constants.emptyFunction);
  }
}

extension CachedItemExtension on CachedItem {
  bool isValid({
    required int expTimeInMilliSeconds,
  }) {
    // Get current time
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return (currentTime - cacheTime <= expTimeInMilliSeconds);
  }
}
