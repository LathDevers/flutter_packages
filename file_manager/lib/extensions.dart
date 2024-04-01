import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_manager/types.dart';
import 'package:intl/intl.dart';

extension FileExtensions on File {
  Future<void> writeCSV(String fieldDelimiter, List<List<String>> content) async {
    await writeAsString(ListToCsvConverter(fieldDelimiter: fieldDelimiter).convert(content));
  }
}

extension ListListDynamicExtensions on List<List<dynamic>> {
  List<List<String>> get toListListString {
    // input.map((row) => row.map((e) => e.toString()).toList()).toList() dauert laenger als die for-Schleifen
    // row.cast<String>() funktioniert nicht
    final List<List<String>> output = [];
    for (final List<dynamic> row in this) output.add(row.map((e) => e.toString()).toList());
    return output;
  }
}

extension ListListStringExtensions on List<List<String>> {
  int? getHeaderRow(String date) {
    int result = indexWhere((row) => DateTime.tryParse('${date}T${row[0]}') != null) - 1;
    if (result < 0) result = indexWhere((row) => row[0] == 'Timestamp');
    return (result < 0) ? null : result;
  }
}

extension DateTimeExtensions on DateTime {
  double get toSeconds => millisecond / 1000 + second + (minute + hour * 60) * 60;

  String dateTime2String(String decimal) {
    return DateFormat('kk:mm:ss').format(this) + decimal + NumberFormat('000').format(millisecond);
  }
}

extension NumberFormatExtensions on MyNumberFormat {
  Future<String?> getDelimiter(String? defaultDelimiter) async {
    return switch (this) {
      MyNumberFormat.de_DE => ';',
      MyNumberFormat.en_US => ',',
      MyNumberFormat.manual => defaultDelimiter,
    };
  }

  Future<String?> getDecimal(String? defaultDecimal) async {
    return switch (this) {
      MyNumberFormat.de_DE => ',',
      MyNumberFormat.en_US => '.',
      MyNumberFormat.manual => defaultDecimal,
    };
  }
}

extension NullableStringExtensions on String? {
  bool get isUsername {
    if (this == null) return false;
    const List<String> blacklist = [
      '',
      'username',
      'benutzername',
      'user name',
      'benutzer name',
    ];
    return !blacklist.contains(this!.toLowerCase());
  }
}

extension StringExtensions on String {
  String get fileNameWithExtension {
    final List<String> pathParts = split('/');
    final String fileName = pathParts.removeLast();
    return fileName;
  }
}

extension DoubleExtensions on double {
  String double2String(String locale) => NumberFormat('#.######', locale).format(this);
}
