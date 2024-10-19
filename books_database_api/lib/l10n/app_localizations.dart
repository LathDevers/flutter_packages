import 'package:books_database_api/l10n/app_localizations_de.dart';
import 'package:books_database_api/l10n/app_localizations_en.dart';
import 'package:books_database_api/l10n/app_localizations_hu.dart';

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
        'hu' => PackageLocalizationsHu(),
        _ => throw Exception('Unsupported locale: $locale'),
      };

  String get flagImagePath => _currentLocalizations.flagImagePath;

  String get by => _currentLocalizations.by;

  String writer(int count) => _currentLocalizations.writer(count);

  String get publisher => _currentLocalizations.publisher;

  String get publishedOn => _currentLocalizations.publishedOn;

  String get rating => _currentLocalizations.rating;

  String get category => _currentLocalizations.category;
}
