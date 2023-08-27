enum LanguageType {
  ENGLISH,
  ARABIC,
}

const String ENGLISH = 'en';
const String ARABIC = 'ar';

extension LangugageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
      default:
        return ENGLISH;
    }
  }
}
