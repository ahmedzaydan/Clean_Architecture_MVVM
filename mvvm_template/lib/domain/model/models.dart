// Onboarding models
class SliderObject {
  String image;
  String subTitle;
  String title;

  SliderObject(
    this.title,
    this.subTitle,
    this.image,
  );
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(
    this.sliderObject,
    this.numOfSlides,
    this.currentIndex,
  );
}

// Login models
class Customer {
  String id;
  String name;
  int numOfNotifications;

  Customer({
    required this.id,
    required this.name,
    required this.numOfNotifications,
  });
}

class Contacts {
  String phone;
  String email;
  String link;

  Contacts({
    required this.phone,
    required this.email,
    required this.link,
  });
}

class Authentication {
  Customer? customer;
  Contacts? contacts;

  Authentication({
    required this.customer,
    required this.contacts,
  });
}

class ForgotPassword {
  String message;

  ForgotPassword({
    required this.message,
  });
}

class Service {
  int id;
  String title;
  String image;

  Service({
    required this.id,
    required this.title,
    required this.image,
  });
}

class BannerAd {
  int id;
  String link;
  String title;
  String image;

  BannerAd({
    required this.id,
    required this.link,
    required this.title,
    required this.image,
  });
}

class Store {
  int id;
  String title;
  String image;

  Store({
    required this.id,
    required this.title,
    required this.image,
  });
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData({
    required this.services,
    required this.banners,
    required this.stores,
  });
}

class HomeObject {
  HomeData data;

  HomeObject({
    required this.data,
  });
}

class StoreDetails {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;

  StoreDetails({
    required this.image,
    required this.id,
    required this.title,
    required this.details,
    required this.services,
    required this.about,
  });
}
