import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/data/response/responses.dart';
import 'package:mvvm_template/domain/model/models.dart';

import '../../presentation/resources/strings_manager.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      id: this?.id.orEmpty() ?? AppStrings.empty,
      name: this?.name.orEmpty() ?? AppStrings.empty,
      numOfNotifications: this?.numOfNotifications.orZero() ?? Constants.zero,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      phone: this?.phone.orEmpty() ?? AppStrings.empty,
      email: this?.email.orEmpty() ?? AppStrings.empty,
      link: this?.link.orEmpty() ?? AppStrings.empty,
    );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      customer: this?.customer.toDomain(),
      contacts: this?.contacts.toDomain(),
    );
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse {
  ForgotPassword toDomain() {
    return ForgotPassword(
      message: message.orEmpty(),
    );
  }
}
