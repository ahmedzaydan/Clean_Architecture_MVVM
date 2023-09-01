import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/presentation/base/base_viewmodel.dart';
import 'package:mvvm_template/presentation/resources/assets_manager.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    implements OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // Stream controllers outputs
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // Onboarding view model inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    // View model start your job
    _list = _getSliderData();

    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (_currentIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (_currentIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject {
    return _streamController.sink;
  }

  // On boarding view model outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject {
    return _streamController.stream.map(
      (sliderViewObject) {
        return sliderViewObject;
      },
    );
  }

  // Onboarding private functions
  _postDataToView() {
    inputSliderViewObject.add(
      SliderViewObject(
        _list[_currentIndex],
        _list.length,
        _currentIndex,
      ),
    );
  }

  List<SliderObject> _getSliderData() {
    return [
      SliderObject(
        AppStrings.onBoardingTitle1.tr(),
        AppStrings.onBoardingSubTitle1.tr(),
        ImageAssets.onBoardingLogo1,
      ),
      SliderObject(
        AppStrings.onBoardingTitle2.tr(),
        AppStrings.onBoardingSubTitle2.tr(),
        ImageAssets.onBoardingLogo2,
      ),
      SliderObject(
        AppStrings.onBoardingTitle3.tr(),
        AppStrings.onBoardingSubTitle3.tr(),
        ImageAssets.onBoardingLogo3,
      ),
      SliderObject(
        AppStrings.onBoardingTitle4.tr(),
        AppStrings.onBoardingSubTitle4.tr(),
        ImageAssets.onBoardingLogo4,
      ),
    ];
  }
}

// Inputs means "orders" that our view model will receive from view
abstract class OnBoardingViewModelInputs {
  int goNext(); // When user clicks on right arrow or swipes left

  int goPrevious(); // When user clicks on left arrow or swipes right

  void onPageChanged(int index);

  // Stream controller input
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  // Stream controller output
  Stream<SliderViewObject> get outputSliderViewObject;
}
