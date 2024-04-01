import 'package:datatype_extensions/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:basics/basics.dart';

extension DateTimeExtension on DateTime {
  /// Returns a string representation of this [DateTime] instance.
  ///
  /// If value is today => return how many hours/minutes/seconds ago.
  ///
  /// If value was yesterday => returned "yesterday" localised.
  ///
  /// If value is in this week => return "weekday" localised. (i.e. Monday, Tuesday, ... Sunday)
  ///
  /// Otherwise return value in a given [pattern].
  String describe(String locale, [String pattern = 'E d. MMM yy']) {
    if (isToday) return _buildToday(locale);
    if (isYesterday) return PackageLocalizations(locale).yesterday;
    if (isThisWeek) return DateFormat('EEEE', locale).format(this);
    return DateFormat(pattern, locale).format(this);
  }

  /// Returns a string representation of this [DateTime] instance.
  ///
  /// If value is in the past => return how many hours/minutes/seconds ago.
  ///
  /// If value is in the future => return how many hours/minutes/seconds in the future.
  String _buildToday(String locale) {
    final Duration difference = this.difference(DateTime.now());
    final int inHours = difference.inHours.abs();
    final int inMinutes = difference.inMinutes.abs();
    final int inSeconds = difference.inSeconds.abs();
    if (difference > Duration.zero) {
      if (inHours == 0) {
        if (inMinutes == 0)
          return PackageLocalizations(locale).inSeconds(inSeconds).capitalize();
        else
          return PackageLocalizations(locale).inMinutes(inMinutes).capitalize();
      } else
        return PackageLocalizations(locale).inHours(inHours).capitalize();
    }
    if (inHours == 0) {
      if (inMinutes == 0)
        return PackageLocalizations(locale).secondsAgo(inSeconds);
      else
        return PackageLocalizations(locale).minutesAgo(inMinutes);
    } else
      return PackageLocalizations(locale).hoursAgo(inHours);
  }

  /// Returns true if this [DateTime] is today.
  bool get isToday => _diffDays == 0;

  /// Returns true if this [DateTime] is yesterday.
  bool get isYesterday => _diffDays == 1;

  /// Returns true if this [DateTime] is in the same week as today.
  bool get isThisWeek {
    final int diffDays = _diffDays;
    final int weekday = DateTime.now().weekday; // Mo=1 ... Su=7
    if (diffDays.isNegative) {
      // value is in the future
      return diffDays.abs() <= (7 - weekday);
    } else {
      // value is in the past
      return diffDays < weekday;
    }
  }

  int get _diffDays {
    final DateTime now = DateTime.now();
    final DateTime nowAlt = DateTime(now.year, now.month, now.day);
    final double nowDays = nowAlt.millisecondsSinceEpoch ~/ 864 / 1e5;
    final double dataDays = millisecondsSinceEpoch ~/ 864 / 1e5;
    return (nowDays - dataDays).ceil();
  }
}
