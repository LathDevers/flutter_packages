import 'package:datatype_extensions/l10n/app_localizations_de.dart';
import 'package:datatype_extensions/l10n/app_localizations_en.dart';

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

  String hoursAgo(int count) => _currentLocalizations.hoursAgo(count);

  String minutesAgo(int count) => _currentLocalizations.minutesAgo(count);

  String secondsAgo(int count) => _currentLocalizations.secondsAgo(count);

  String inHours(int count) => _currentLocalizations.inHours(count);

  String inMinutes(int count) => _currentLocalizations.inMinutes(count);

  String inSeconds(int count) => _currentLocalizations.inSeconds(count);

  String get yesterday => _currentLocalizations.yesterday;
}
