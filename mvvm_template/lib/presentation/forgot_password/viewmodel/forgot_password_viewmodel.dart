import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_template/domain/usecase/forgot_password_usecase.dart';
import 'package:mvvm_template/presentation/base/base_viewmodel.dart';
import 'package:mvvm_template/presentation/common/freezed_data_classes.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';

import '../../../app/functions.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    implements ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  // Stream controllers
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  ForgotPasswordObject forgotPasswordObject =
      ForgotPasswordObject(email: AppStrings.empty.tr());

  // Inputs
  @override
  void start() {
    // View model should tell view, please show content state
    inputState.add(ContentState());
  }

  @override
  void setEmail(String email) {
    forgotPasswordObject = forgotPasswordObject.copyWith(email: email);
    inputEmail.add(email);
    inputAreAllInputsValid.add(null);
  }

  @override
  void forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(
            ForgotPasswordUseCaseInput(email: forgotPasswordObject.email)))
        .fold((failure) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: failure.message,
        ),
      );
    }, (supportMessage) {
      if (kDebugMode) {
        print("ForgotPasswordViewModel: $supportMessage");
      }
      inputState.add(SuccessState(supportMessage.message));
    });
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputValidStreamController.sink;

  // Outputs
  @override
  void dispose() {
    _emailStreamController.close();
    _areAllInputValidStreamController.close();
    super.dispose();
  }

  @override
  Stream<bool> get outIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputValidStreamController.stream
          .map((areAllInputsValid) => _areAllInputsValid());
  
  bool _areAllInputsValid() {
    return isEmailValid(forgotPasswordObject.email);
  }
}

abstract class ForgotPasswordViewModelInputs {
  void setEmail(String email);
  void forgotPassword();

  Sink get inputEmail;
  Sink get inputAreAllInputsValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outIsEmailValid;
  Stream<bool> get outAreAllInputsValid;
}
