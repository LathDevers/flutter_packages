import 'package:datatype_extensions/l10n/app_localizations.dart';

/// The translations for German (`de`).
class PackageLocalizationsDe extends PackageLocalizations {
  PackageLocalizationsDe([super.locale = 'de']);

  @override
  String hoursAgo(int count) {
    return pluralLogic(
      count,
      other: '$count Stunden zuvor',
      one: '1 Stunde zuvor',
    );
  }

  @override
  String minutesAgo(int count) {
    return pluralLogic(
      count,
      other: '$count Minuten zuvor',
      one: '1 Minute zuvor',
    );
  }

  @override
  String secondsAgo(int count) {
    return pluralLogic(
      count,
      other: '$count Sekunden zuvor',
      one: '1 Sekunde zuvor',
    );
  }

  @override
  String inHours(int count) {
    return pluralLogic(
      count,
      other: 'in $count Stunden',
      one: 'in 1 Stunde',
    );
  }

  @override
  String inMinutes(int count) {
    return pluralLogic(
      count,
      other: 'in $count Minuten',
      one: 'in 1 Minute',
    );
  }

  @override
  String inSeconds(int count) {
    return pluralLogic(
      count,
      other: 'in $count Sekunden',
      one: 'in 1 Sekunde',
    );
  }

  @override
  String get yesterday => 'Gestern';
}
