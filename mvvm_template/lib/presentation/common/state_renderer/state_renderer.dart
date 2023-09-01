import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mvvm_template/presentation/resources/assets_manager.dart';
import 'package:mvvm_template/presentation/resources/font_manager.dart';
import 'package:mvvm_template/presentation/resources/styles_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';

import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';

enum StateRendererType {
  // Pop up states (dialog)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,
  // Full screen states
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // General states
  contentState,
}

// Class which will return UI based on state type
class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final Function function;

  const StateRenderer({
    super.key,
    required this.stateRendererType,
    this.message = AppStrings.loading,
    this.title = AppStrings.empty,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(
            context, [_getAnimatedJsonImage(JsonAssets.loading)]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(
          context,
          [
            _getAnimatedJsonImage(JsonAssets.error),
            _getMessage(message),
            _getButton(AppStrings.ok.tr(), context),
          ],
        );
      case StateRendererType.popupSuccessState:
        return _getPopupDialog(
          context,
          [
            _getAnimatedJsonImage(JsonAssets.success),
            _getMessage(message),
            _getButton(AppStrings.ok.tr(), context),
          ],
        );
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn(children: [
          _getAnimatedJsonImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn(children: [
          _getAnimatedJsonImage(JsonAssets.error),
          _getMessage(message),
          _getButton(AppStrings.retryAgain.tr(), context),
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn(children: [
          _getAnimatedJsonImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  // Function returns column with dynamic children
  Widget _getItemsColumn({
    required List<Widget> children,
    bool minSize = false,
  }) {
    return Column(
      mainAxisSize: minSize ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  // Get animated json image
  Widget _getAnimatedJsonImage(String animationName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  // Get message with custom style
  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18,
          ),
        ),
      ),
    );
  }

  // Returns button with custom style
  Widget _getButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType == StateRendererType.fullScreenErrorState) {
                function(); // Call retry action function
              } else {
                // Popup error state, so dismiss dialog when click on ok button
                Navigator.of(context).pop();
              }
            },
            child: Text(buttonTitle),
          ),
        ),
      ),
    );
  }

  // Returns popup dialog
  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: ColorManager.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black26,
            ),
          ],
        ),
        child: _getItemsColumn(
          children: children,
          minSize: true,
        ),
      ),
    );
  }
}
