import 'dart:io';
import 'dart:convert';

import 'package:file_manager/extensions.dart';
import 'package:file_manager/types.dart';
import 'package:csv/csv.dart';

/// Opens and reads the given [ReadInput.file] and returns its content.
Future<MyLoggedDataWrapped> readFile(ReadInput input) async {
  final File file = input.file;
  final String? delimiter = await input.formatting.getDelimiter(input.delimiter);
  final String? decimal = await input.formatting.getDecimal(input.decimal);
  final List<List<dynamic>> read = await file
      .openRead()
      .transform(utf8.decoder)
      .transform(
        CsvToListConverter(fieldDelimiter: delimiter),
      )
      .toList()
      .timeout(const Duration(seconds: 10), onTimeout: () => []);
  if (read.isEmpty) return const MyLoggedDataWrapped(data: {}, errors: [MyError(code: 1500)]);
  final List<List<String>> table = read.toListListString;
  final String date = file.path.split('/').last.split('_').first;
  final int? headerRow = table.getHeaderRow(date);
  // 20211014_103529_bvF272_ecg
  if (headerRow == null) return const MyLoggedDataWrapped(data: {}, errors: [MyError(code: 1501)]);
  if (headerRow + 1 >= table.length) {
    // file is not completely empty, there is header, but nothing else
    final Map<String, MyLoggedData> map = {};
    for (int c = 1; c < table[headerRow].indexWhere((e) => e == ''); c++) {
      map[table[headerRow][c]] = MyLoggedData(
        header: table,
        time: [],
        elapsedTime: [],
        data: [],
      );
    }
    return MyLoggedDataWrapped(errors: [const MyError(code: 1502)], data: map);
  } else {
    final Map<String, MyLoggedData> map = {};
    final List<MyError> errors = [];
    for (int c = 1; c < table[headerRow + 1].length; c++) {
      final List<DateTime> time = [];
      final List<double> elapsedTime = [];
      final List<double> data = [];
      double tDs = 0;
      for (int r = headerRow + 1; r < table.length; r++) {
        // time
        DateTime t;
        try {
          t = DateTime.parse('${date}T${table[r][0]}');
        } on FormatException catch (e) {
          // If for some reason time cannot be parsed, a FormatException is thrown
          // So far I've had a problem, that there was a '\n' in the table
          // here you can add all expressions, that should be removed if FormatException
          final String time0 = table[r][0].replaceAll(RegExp('\n'), '');
          print('${file.path} ::: $time0');
          t = DateTime.parse('${date}T$time0');
          errors.add(MyError(row: r, code: 500, comment: e.toString()));
        }
        if (time.isNotEmpty && t.isBefore(time.last)) errors.add(MyError(row: r, code: 1000));
        time.add(t);
        // elapsedTime
        final double tD = t.toSeconds;
        if (r == headerRow + 1) tDs = tD; // initialize Nullpunkt
        elapsedTime.add(tD - tDs);
        // data
        data.add(double.parse(table[r][c].replaceAll(decimal ?? ',', '.')));
      }
      map[table[headerRow][c]] = MyLoggedData(
        header: table.sublist(0, headerRow + 1),
        time: time,
        elapsedTime: elapsedTime,
        data: data,
      );
    }
    return MyLoggedDataWrapped(errors: errors, data: map);
  }
}
