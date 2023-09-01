import 'package:easy_localization/easy_localization.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/data/response/responses.dart';
import 'package:mvvm_template/domain/model/models.dart';

import '../../presentation/resources/strings_manager.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      id: this?.id.orEmpty() ?? AppStrings.empty.tr(),
      name: this?.name.orEmpty() ?? AppStrings.empty.tr(),
      numOfNotifications: this?.numOfNotifications.orZero() ?? Constants.zero,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      phone: this?.phone.orEmpty() ?? AppStrings.empty.tr(),
      email: this?.email.orEmpty() ?? AppStrings.empty.tr(),
      link: this?.link.orEmpty() ?? AppStrings.empty.tr(),
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

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
      id: this?.id.orZero() ?? Constants.zero,
      title: this?.title.orEmpty() ?? AppStrings.empty.tr(),
      image: this?.image.orEmpty() ?? AppStrings.empty.tr(),
    );
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
      id: this?.id.orZero() ?? Constants.zero,
      link: this?.link.orEmpty() ?? AppStrings.empty.tr(),
      title: this?.title.orEmpty() ?? AppStrings.empty.tr(),
      image: this?.image.orEmpty() ?? AppStrings.empty.tr(),
    );
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(
      id: this?.id.orZero() ?? Constants.zero,
      title: this?.title.orEmpty() ?? AppStrings.empty.tr(),
      image: this?.image.orEmpty() ?? AppStrings.empty.tr(),
    );
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = (this?.data?.services?.map(
                  (serviceResponse) => serviceResponse.toDomain(),
                ) ??
            const Iterable.empty())
        .cast<Service>()
        .toList();

    List<BannerAd> banners = (this?.data?.banners?.map(
                  (bannerResponse) => bannerResponse.toDomain(),
                ) ??
            const Iterable.empty())
        .cast<BannerAd>()
        .toList();

    List<Store> stores = (this?.data?.stores?.map(
                  (storeResponse) => storeResponse.toDomain(),
                ) ??
            const Iterable.empty())
        .cast<Store>()
        .toList();

    var data = HomeData(
      services: services,
      banners: banners,
      stores: stores,
    );
    return HomeObject(data: data);
  }
}

extension StoreDetailsMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
      image: this?.image.orEmpty() ?? AppStrings.empty.tr(),
      id: this?.id.orZero() ?? Constants.zero,
      title: this?.title.orEmpty() ?? AppStrings.empty.tr(),
      details: this?.details.orEmpty() ?? AppStrings.empty.tr(),
      services: this?.services.orEmpty() ?? AppStrings.empty.tr(),
      about: this?.about.orEmpty() ?? AppStrings.empty.tr(),
    );
  }
}
