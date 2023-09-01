import 'package:mvvm_template/app/constants.dart';

enum LanguageType {
  english,
  arabic,
}


extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return Constants.english;
      case LanguageType.arabic:
        return Constants.arabic;
      default:
        return Constants.english;
    }
  }
}
