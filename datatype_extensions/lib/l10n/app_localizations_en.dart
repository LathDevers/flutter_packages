import 'package:datatype_extensions/l10n/app_localizations.dart';

/// The translations for English (`en`).
class PackageLocalizationsEn extends PackageLocalizations {
  PackageLocalizationsEn([super.locale = 'en']);

  @override
  String hoursAgo(int count) {
    return pluralLogic(
      count,
      other: '$count hours ago',
      one: '1 hour ago',
    );
  }

  @override
  String minutesAgo(int count) {
    return pluralLogic(
      count,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
  }

  @override
  String secondsAgo(int count) {
    return pluralLogic(
      count,
      other: '$count seconds ago',
      one: '1 second ago',
    );
  }

  @override
  String inHours(int count) {
    return pluralLogic(
      count,
      other: 'in $count hours',
      one: 'in 1 hour',
    );
  }

  @override
  String inMinutes(int count) {
    return pluralLogic(
      count,
      other: 'in $count minutes',
      one: 'in 1 minute',
    );
  }

  @override
  String inSeconds(int count) {
    return pluralLogic(
      count,
      other: 'in $count seconds',
      one: 'in 1 second',
    );
  }

  @override
  String get yesterday => 'Yesterday';
}
