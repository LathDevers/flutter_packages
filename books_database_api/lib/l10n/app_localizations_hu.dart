import 'package:books_database_api/l10n/app_localizations.dart';

/// The translations for Hungarian (`hu`).
class PackageLocalizationsHu extends PackageLocalizations {
  PackageLocalizationsHu([super.locale = 'hu']);

  @override
  String get flagImagePath => 'images/flag_hu.png';

  @override
  String get by => 'Szerző:';

  @override
  String writer(int count) => pluralLogic(
        count,
        other: 'Autoren',
        one: 'Autor',
      );

  @override
  String get publisher => 'Kiadó';

  @override
  String get publishedOn => 'Megjelenés';

  @override
  String get rating => 'Értékelés';

  @override
  String get category => 'Kategória';
}
