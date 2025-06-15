import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:file_manager/get_application_directory.dart';
import 'package:file_manager/extensions.dart';
import 'package:file_manager/types.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast_message.dart';

class WriteCSV {
  WriteCSV.inTemp()
      : _directory = MyDirectory.temporary,
        subFolder = null;
  WriteCSV.inAppDir({this.subFolder}) : _directory = MyDirectory.documents;

  final MyDirectory _directory;
  final String? subFolder;
  File? _file;
  String _delimiteri = ';';
  String _decimali = ','; // default formatter: de-DE

  Future<void> create(
    List<List<String>> header, [
    MyNumberFormat formatting = MyNumberFormat.de_DE,
    String? delimiter,
    String? decimal,
    String? userName,
  ]) async {
    final String dirPath = switch (_directory) {
      MyDirectory.temporary => (await getTemporaryDirectory()).path,
      MyDirectory.documents => (await getApplicationDocumentsDirectorySub(subFolder)).path,
    };
    final DateTime now = DateTime.now();
    final String date = DateFormat('yyyyMMdd_kkmmss').format(now);
    final String dateO = DateFormat('yyyy/MM/dd').format(now);
    // read settings
    switch (formatting) {
      case MyNumberFormat.manual:
        if (delimiter == null || decimal == null) throw Exception('Please provide formatting information!');
        _delimiteri = delimiter;
        _decimali = decimal;
        break;
      case MyNumberFormat.de_DE:
        _delimiteri = ';';
        _decimali = ',';
        break;
      case MyNumberFormat.en_US:
        _delimiteri = ',';
        _decimali = '.';
        break;
    }
    // open file and write first row
    final StringBuffer csvdata = StringBuffer();
    _file = File('$dirPath/$date.csv');
    header[0] += userName.isUsername ? ['', userName!, dateO] : ['', dateO];
    for (final List<String> row in header) csvdata.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([row])}\r\n');
    await _file!.writeAsString(csvdata.toString());
  }

  /// Encodes the file into a ZIP folder and shares it
  Future<bool> shareFile(bool deleteOriginal, DateTime date, [String? userName]) async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    bool result = true;
    try {
      // compress files
      late String zipPath;
      final String dirPath = await getTemporaryDirectory().then((value) => value.path);
      final String dateString = DateFormat('yyyyMMdd_kkmmss').format(date);
      zipPath = userName.isUsername ? '$dirPath/${dateString}_Measurement_$userName.zip' : '$dirPath/${dateString}_Measurement.zip';
      final ZipFileEncoder encoder = ZipFileEncoder()..create(zipPath);
      await encoder.addFile(_file!);
      await encoder.close();
      // share compressed zip file
      final ShareResult shareResult = await SharePlus.instance.share(ShareParams(files: [XFile(zipPath)]));
      if (shareResult.status == ShareResultStatus.dismissed) result = false;
      if (shareResult.status == ShareResultStatus.unavailable) result = false;
      // delete all the files
      await Future.delayed(const Duration(seconds: 2));
      if (deleteOriginal) await _file!.delete();
      await File(zipPath).delete();
    } catch (_) {
      result = false;
    }
    return result;
  }

  /// On Android, this method downloads the file into the Downloads folder.
  /// On iOS, this method shares the file via the share sheet.
  ///
  /// If `deleteOriginal` is true, the original file is deleted after copying.
  /// `date` is used to name the ZIP folder.
  ///
  /// Returns `true` if the operation was successful, `false` otherwise. May throw an exception, that is however overridden in release mode.
  Future<bool> downloadFile([bool deleteOriginal = false, DateTime? date, String? userName]) async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    // Unable to save to Downloads folder on iOS
    date ??= DateTime.now();
    if (Platform.isIOS) return shareFile(deleteOriginal, date);
    // else (on Android) download to Downloads folder
    bool result = true;

    /// Get Downloads directory path
    final String? dirPath = _getDownloadsFolder();
    if (dirPath == null) {
      // if no Downloads folder found, use sharing
      print('No Downloads folder found');
      return shareFile(deleteOriginal, date);
    }

    // Copy one file to Download folder
    final String fileName = _file!.path.fileNameWithExtension;
    result = await _copy(File('$dirPath/$fileName'));
    if (result) {
      unawaited(MyToast.showToast(message: 'Downloaded $fileName to Downloads folder'));
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      result = await shareFile(deleteOriginal, date);
    }
    if (deleteOriginal) await deleteFile();
    return result;
  }

  Future<bool> _copy(File copy) async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    bool result = true;
    try {
      await _file!.copy(copy.path).timeout(const Duration(milliseconds: 1000), onTimeout: () {
        result = false;
        return _file!;
      });
    } catch (e) {
      print(e);
      result = false;
    }
    return result;
  }

  static String? _getDownloadsFolder() {
    const String downloads = '/storage/emulated/0/Downloads';
    if (Directory(downloads).existsSync()) return downloads;
    const String download = '/storage/emulated/0/Download';
    if (Directory(download).existsSync()) return download;
    return null;
  }

  /// Returns `true`, if every file was deleted successfully.
  /// Returns `false` if cannot be deleted.
  Future<bool> deleteFile() async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    try {
      await _file!.delete();
    } on Exception catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  /// Returns a list of entities. Properties of an entity are: name of entity, type of entity and entity's full path.
  ///
  /// Type of entity can be: `<file extension>`, if a folder: `dir` and if not a folder but has no extension: `?`.
  static Future<List<MyFileSystemEntity>> listFolder({Directory? path, String? appDirSub}) async {
    path ??= await getApplicationDocumentsDirectorySub(appDirSub);
    final List<FileSystemEntity> filesInDir = path.listSync();
    final List<MyFileSystemEntity> fileNames = [];
    for (final e in filesInDir) {
      final String entityName = e.path.split('/').last;
      if (e is File) {
        if (entityName.split('.').last != entityName) {
          // file has extension
          final List<String> d = entityName.split('.');
          final String ext = d.removeLast();
          final String fileName = d.join();
          fileNames.add(MyFileSystemEntity(fileName: fileName, fileNameWithExtension: entityName, type: ext, path: e.path));
        } else {
          // file has no extension
          fileNames.add(MyFileSystemEntity(fileName: entityName, fileNameWithExtension: entityName, type: '?', path: e.path));
        }
      } else if (e is Directory) {
        fileNames.add(MyFileSystemEntity(fileName: entityName, fileNameWithExtension: entityName, type: 'dir', path: e.path));
      } else {
        fileNames.add(MyFileSystemEntity(fileName: entityName, fileNameWithExtension: entityName, type: '', path: e.path));
      }
    }
    return fileNames;
  }

  /// Opens and reads the given [input.file] and returns its content.
  ///
  /// This function is a wrapper for [_readFile]. It accomplishes that reading log file runs in a separate thread (i. e. in an isolate). This is achieved by [compute].
  //Future<MyLoggedDataWrapped> readFile(ReadInput input) async {
  //  return await compute(_readFile, input);
  //}
  Future<MyResult> read() async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    final File file = _file!;
    final String delimiter = _delimiteri;
    final List<List<dynamic>> read = await file
        .openRead()
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(fieldDelimiter: delimiter),
        )
        .toList()
        .timeout(const Duration(seconds: 10), onTimeout: () => []);
    if (read.isEmpty)
      return const MyResult(
        errors: [MyError(code: 1500)],
        header: [],
        data: [],
      );
    final List<List<String>> table = read.toListListString;
    final String date = file.path.split('/').last.split('_').first;
    final int? headerRow = _getHeaderRow(date, table);
    // 20211014_103529_bvF272_ecg
    if (headerRow == null)
      return const MyResult(
        errors: [MyError(code: 1501)],
        header: [],
        data: [],
      );
    if (headerRow + 1 >= table.length) {
      // file is not completely empty, there is header, but nothing else
      return MyResult(
        errors: [const MyError(code: 1502)],
        header: table,
        data: [],
      );
    } else {
      final List<MyError> errors = [];
      final List<({DateTime time, double elapsedTime, List<String> row})> data = [];
      double tDs = 0;
      for (int r = headerRow + 1; r < table.length; r++) {
        // time
        DateTime t;
        try {
          t = DateTime.parse('${date}T${table[r][0]}');
        } on FormatException catch (e) {
          // If for some reason time cannot be parsed, a FormatException is thrown
          // So far I've had a problem, there there was a '\n' in the table
          // here you can add all expressions, that should be removed if FormatException
          final String time0 = table[r][0].replaceAll(RegExp('\n'), '');
          print('${file.path} ::: $time0');
          t = DateTime.parse('${date}T$time0');
          errors.add(MyError(row: r, code: 500, comment: e.toString()));
        }
        if (data.isNotEmpty && t.isBefore(data.last.time)) errors.add(MyError(row: r, code: 1000));
        // elapsedTime
        final double tD = t.toSeconds;
        if (r == headerRow + 1) tDs = tD; // initialize Nullpunkt
        // data
        data.add((time: t, elapsedTime: tD - tDs, row: table[r].sublist(1)));
      }
      return MyResult(
        errors: errors,
        header: table.sublist(0, headerRow + 1),
        data: data,
      );
    }
  }

  /// Return true if successful.
  Future<bool> write(DateTime time, List<String> data) async {
    if (_file == null) {
      throw Exception('No file found! First call create()!');
    }
    try {
      final StringBuffer csvData = StringBuffer();
      if (data.isNotEmpty) {
        csvData.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([
              [dateTime2String(time, _decimali)] + data
            ])}\r\n');
      } else {
        csvData.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([
              [dateTime2String(time, _decimali)]
            ])}\r\n');
      }
      await _file!.writeAsString(csvData.toString(), mode: FileMode.writeOnlyAppend);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns true if successful.
  Future<bool> deleteRow(int index) async {
    final MyResult content = await read();
    if (content.errors.isNotEmpty) return false;
    content.data.removeAt(index);
    try {
      final StringBuffer csvData = StringBuffer()..write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert(content.header)}\r\n');
      for (final ({double elapsedTime, List<String> row, DateTime time}) row in content.data) {
        if (row.row.isNotEmpty) {
          csvData.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([
                [dateTime2String(row.time, _decimali)] + row.row
              ])}\r\n');
        } else {
          csvData.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([
                [dateTime2String(row.time, _decimali)]
              ])}\r\n');
        }
      }
      await _file!.writeAsString(csvData.toString(), mode: FileMode.writeOnly);
      return true;
    } catch (e) {
      return false;
    }
  }

  static int? _getHeaderRow(String date, List<List<String>> table) {
    int result = table.indexWhere((row) => DateTime.tryParse('${date}T${row[0]}') != null) - 1;
    if (result < 0) result = table.indexWhere((row) => row[0] == 'Timestamp');
    return (result < 0) ? null : result;
  }

  static String dateTime2String(DateTime dateTime, String decimal) {
    return DateFormat('kk:mm:ss').format(dateTime) + decimal + NumberFormat('000').format(dateTime.millisecond);
  }
}
