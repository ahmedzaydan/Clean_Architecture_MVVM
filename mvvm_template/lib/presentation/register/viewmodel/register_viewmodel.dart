import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/functions.dart';
import 'package:mvvm_template/domain/usecase/register_usecase.dart';
import 'package:mvvm_template/presentation/base/base_viewmodel.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';

import '../../common/freezed_data_classes.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class RegisterViewModel extends BaseViewModel
    implements RegisterViewModelInputs, RegisterViewModelOutputs {
  // Stream controllers
  final StreamController _usernameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _phoneStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isUserRegisteredSuccessfullyStreamController =
      StreamController<bool>();


  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  RegisterObject registerObject = RegisterObject(
    username: AppStrings.empty.tr(),
    email: AppStrings.empty.tr(),
    password: AppStrings.empty.tr(),
    phoneNumber: AppStrings.empty.tr(),
    countryCode: AppStrings.empty.tr(),
    profilePicture: AppStrings.empty.tr(),
  );

  // Inputs

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(
      RegisterUseCaseInput(
        email: registerObject.email,
        password: registerObject.password,
        username: registerObject.username,
        phone: registerObject.phoneNumber,
        countryCode: registerObject.countryCode,
        photo: registerObject.profilePicture,
      ),
    ))
        .fold((failure) {
      inputState.add(ErrorState(
        stateRendererType: StateRendererType.popupErrorState,
        message: failure.message,
      ));
    }, (data) {
      inputState.add(ContentState());
      isUserRegisteredSuccessfullyStreamController.add(true);
    });
  }

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputPhone => _phoneStreamController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;

  @override
  void setUsername(String username) {
    inputUsername.add(username);
    if (_isUsernameValid(username)) {
      registerObject = registerObject.copyWith(username: username);
    } else {
      // Reset username
      registerObject = registerObject.copyWith(username: AppStrings.empty.tr());
    }
    _validate();
  }

  @override
  void setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      registerObject = registerObject.copyWith(password: password);
    } else {
      // Reset password
      registerObject = registerObject.copyWith(password: AppStrings.empty.tr());
    }
    _validate();
  }

  @override
  void setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      registerObject = registerObject.copyWith(email: email);
    } else {
      // Reset email
      registerObject = registerObject.copyWith(email: AppStrings.empty.tr());
    }
    _validate();
  }

  @override
  void setPhone(String phone) {
    inputPhone.add(phone);
    if (_isPhoneNumberValid(phone)) {
      registerObject = registerObject.copyWith(phoneNumber: phone);
    } else {
      // Reset phone
      registerObject = registerObject.copyWith(phoneNumber: AppStrings.empty.tr());
    }
    _validate();
  }

  @override
  void setCountryCode(String countryCode) {
    if (_isCountryCodeValid(countryCode)) {
      registerObject = registerObject.copyWith(countryCode: countryCode);
    } else {
      // Reset country code
      registerObject = registerObject.copyWith(countryCode: AppStrings.empty.tr());
    }
    _validate();
  }

  @override
  void setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (_isProfilePictureValid(profilePicture)) {
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // Reset profile picture
      registerObject =
          registerObject.copyWith(profilePicture: AppStrings.empty.tr());
    }
    _validate();
  }

  // Outputs

  // Username
  @override
  Stream<bool> get outputIsUsernameValid => _usernameStreamController.stream
      .map((username) => _isUsernameValid(username));

  @override
  Stream<String?> get outputErrorUsername => outputIsUsernameValid.map(
      (isUsernameValid) => isUsernameValid ? null : AppStrings.invalidUsername.tr());

  // Email
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail.tr());

  // Phone number
  @override
  Stream<bool> get outputIsPhoneValid => _phoneStreamController.stream
      .map((phoneNumber) => _isPhoneNumberValid(phoneNumber));

  @override
  Stream<String?> get outputErrorPhone =>
      outputIsPhoneValid.map((isPhoneNumberValid) =>
          isPhoneNumberValid ? null : AppStrings.invalidPhoneNumber.tr());

  // Password
  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.invalidPassword.tr());

  @override
  Stream<File> get outputProfilePicture =>
      _profilePictureStreamController.stream
          .map((profilePictureFile) => profilePictureFile);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  // Private functions
  bool _isUsernameValid(String username) =>
      username.length >= Constants.usernameLength;

  bool _isPhoneNumberValid(String phoneNumber) =>
      phoneNumber.length >= Constants.phoneNumberLength;

  bool _isCountryCodeValid(String countryCode) => countryCode.isNotEmpty;

  bool _isPasswordValid(String password) =>
      password.length >= Constants.passwordLength;

  bool _isProfilePictureValid(File profilePicture) =>
      profilePicture.path.isNotEmpty;

  bool _areAllInputsValid() {
    return _isUsernameValid(registerObject.username) &&
        _isPasswordValid(registerObject.password) &&
        isEmailValid(registerObject.email) &&
        _isPhoneNumberValid(registerObject.phoneNumber) &&
        _isCountryCodeValid(registerObject.countryCode) &&
        _isProfilePictureValid(File(registerObject.profilePicture));
  }

  void _validate() {
    inputAreAllInputsValid.add(null);
  }

  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _emailStreamController.close();
    _phoneStreamController.close();
    _profilePictureStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserRegisteredSuccessfullyStreamController.close();
    super.dispose();
  }
}

abstract class RegisterViewModelInputs {
  Sink get inputUsername;
  Sink get inputPassword;
  Sink get inputEmail;
  Sink get inputPhone;
  Sink get inputProfilePicture;
  Sink get inputAreAllInputsValid;

  void start();
  void register();

  void setUsername(String username);
  void setPassword(String password);
  void setEmail(String email);
  void setPhone(String phone);
  void setCountryCode(String countryCode);
  void setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputIsUsernameValid;
  Stream<String?> get outputErrorUsername;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPhoneValid;
  Stream<String?> get outputErrorPhone;

  Stream<File> get outputProfilePicture;
  // Stream<String?> get outputErrorProfilePicture;

  Stream<bool> get outputAreAllInputsValid;
}
