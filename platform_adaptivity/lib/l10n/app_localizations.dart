import 'package:platform_adaptivity/l10n/app_localizations_de.dart';
import 'package:platform_adaptivity/l10n/app_localizations_en.dart';

T pluralLogic<T>(int count, {required T one, required T other}) => switch (count) {
      1 => one,
      _ => other,
    };

class PackageLocalizations {
  PackageLocalizations(this.locale);

  final String locale;

  PackageLocalizations get _currentLocalizations => switch (locale) {
        'en' => PackageLocalizationsEn(),
        'de' => PackageLocalizationsDe(),
        _ => throw Exception('Unsupported locale: $locale'),
      };

  String get back => _currentLocalizations.back;
}
