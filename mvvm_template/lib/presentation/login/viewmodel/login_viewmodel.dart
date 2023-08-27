import 'dart:async';

import 'package:mvvm_template/domain/usecase/login_usecase.dart';
import 'package:mvvm_template/presentation/base/base_viewmodel.dart';
import 'package:mvvm_template/presentation/common/freezed_data_classes.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer.dart';

import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/strings_manager.dart';

class LoginViewModel extends BaseViewModel
    implements LoginViewModelInputs, LoginViewModelOutputs {
  // Stream controllers
  final StreamController _usernameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController<void> _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final StreamController<bool> isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  LoginObject loginObject = LoginObject(
    username: AppStrings.empty,
    password: AppStrings.empty,
  );

  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  // Inputs
  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    // View model should tell view, please show content state
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  void setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  void setUsername(String username) {
    inputUsername.add(username);
    loginObject = loginObject.copyWith(username: username);
    inputAreAllInputsValid.add(null);
  }

  @override
  void login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
      LoginUseCaseInput(
        email: loginObject.username,
        password: loginObject.password,
      ),
    ))
        .fold((failure) {
      inputState.add(ErrorState(
        stateRendererType: StateRendererType.popupErrorState,
        message: failure.message,
      ));
    }, (data) {
      inputState.add(ContentState());
      isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  // Outputs
  @override
  Stream<bool> get outIsPasswordValid {
    return _passwordStreamController.stream
        .map((password) => _isPasswordValid(password));
  }

  @override
  Stream<bool> get outIsUsernameValid {
    return _usernameStreamController.stream
        .map((username) => _isUsernameValid(username));
  }

  @override
  Stream<bool> get outAreAllInputsValid {
    return _areAllInputsValidStreamController.stream
        .map((_) => _areAllInputsValid());
  }

  bool _isPasswordValid(String password) => password.isNotEmpty;

  bool _isUsernameValid(String username) => username.isNotEmpty;

  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUsernameValid(loginObject.username);
  }
}

abstract class LoginViewModelInputs {
  void setUsername(String username);
  void setPassword(String password);
  void login();

  Sink get inputUsername;
  Sink get inputPassword;
  Sink get inputAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUsernameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
