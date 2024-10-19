import 'package:books_database_api/l10n/app_localizations.dart';

/// The translations for German (`de`).
class PackageLocalizationsDe extends PackageLocalizations {
  PackageLocalizationsDe([super.locale = 'de']);

  @override
  String get flagImagePath => 'images/flag_de.png';

  @override
  String get by => 'von';

  @override
  String writer(int count) => pluralLogic(
        count,
        other: 'Szerzők',
        one: 'Szerző',
      );

  @override
  String get publisher => 'Verlag';

  @override
  String get publishedOn => 'Veröffentlichung';

  @override
  String get rating => 'Bewertung';

  @override
  String get category => 'Kategorie';
}
