import 'package:books_database_api/l10n/app_localizations.dart';

/// The translations for English (`en`).
class PackageLocalizationsEn extends PackageLocalizations {
  PackageLocalizationsEn([super.locale = 'en']);

  @override
  String get flagImagePath => 'images/flag_en.png';

  @override
  String get by => 'by';

  @override
  String writer(int count) => pluralLogic(
        count,
        other: 'Authors',
        one: 'Author',
      );

  @override
  String get publisher => 'Publisher';

  @override
  String get publishedOn => 'Published on';

  @override
  String get rating => 'Rating';

  @override
  String get category => 'Category';
}
