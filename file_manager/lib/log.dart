import 'dart:async';
import 'dart:io';

import 'package:file_manager/download_files.dart';
import 'package:file_manager/get_application_directory.dart';
import 'package:file_manager/extensions.dart';
import 'package:file_manager/types.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Call this object to control data-logging.
///
/// First initialize by calling `createFiles()` method. The log each individual incoming data by calling `logData()`. At last close logging by using `saveFiles()`.
class LogData {
  LogData.inTemp()
      : _directory = MyDirectory.temporary,
        subFolder = null;
  LogData.inAppDir({this.subFolder}) : _directory = MyDirectory.documents;

  final MyDirectory _directory;
  final String? subFolder;
  final Map<String, File> _files = <String, File>{};
  final Map<String, List<(DateTime, List<double>?)>> _buffer = <String, List<(DateTime, List<double>?)>>{};
  late DateTime _startTime;
  String _delimiteri = ';';
  String _decimali = ','; // default formatter: de-DE
  final String _deviceId = '';
  bool _dumpInProgress = false;

  /// Initializing variables and location service, reading set preferences (`delimiter`, `decimal point`), creating files for each device and UUID.
  ///
  /// Please give a keys and headers map, where header is the first row in the file.
  ///
  /// Please also give a keys and booleans map with the same keys as in the keyAndHeader map, where the boolean should be true, if the data comes from BLE
  /// and false if it comes from the mobile device
  Future<void> createFiles(
    List<String> devices,
    Map<dynamic, List<List<String>>> keyAndHeader,
    Map<dynamic, bool> keyAndBool, [
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
    _startTime = now;
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
    // open files and write first row
    keyAndHeader.forEach((key, value) async {
      final StringBuffer csvdata = StringBuffer();
      if (keyAndBool[key] ?? true) {
        for (final String device in devices) {
          csvdata.clear();
          // Please don't change file name format. Other modules build on this.
          _files[_key(key, device)] = File('$dirPath/${date}_bv${device.substring(6, 8)}${device.substring(9, 11)}_${_dynKey2String(key)}.csv');
          value[0] += userName.isUsername ? ['', userName!, dateO, device] : ['', dateO, device];
          for (final List<String> row in value) csvdata.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([row])}\r\n');
          await _files[_key(key, device)]!.writeAsString(csvdata.toString());
          // initialize/reset data buffer
          _buffer[_key(key, device)] = [];
        }
      } else {
        _files[_key(key)] = File('$dirPath/${date}_${_dynKey2String(key)}.csv');
        value[0] += userName.isUsername ? ['', userName!, dateO] : ['', dateO];
        for (final List<String> row in value) csvdata.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([row])}\r\n');
        await _files[_key(key)]!.writeAsString(csvdata.toString());
        // initialize/reset data buffer
        _buffer[_key(key)] = [];
      }
    });
  }

  String _dynKey2String(dynamic input) {
    if (this is String) return input;
    if (this is Enum) return input.name;
    return input.toString();
  }

  Future<void> createFile(
    List<List<String>> header,
    MyNumberFormat formatting, [
    String? delimiter,
    String? decimal,
    String? userName,
  ]) async {
    String dirPath = '';
    switch (_directory) {
      case MyDirectory.temporary:
        dirPath = (await getTemporaryDirectory()).path;
        break;
      case MyDirectory.documents:
        dirPath = (await getApplicationDocumentsDirectorySub(subFolder)).path;
        break;
    }
    final DateTime now = DateTime.now();
    _startTime = now;
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
    _files[_key('oneFile')] = File('$dirPath/$date}.csv');
    header[0] += userName.isUsername ? ['', userName!, dateO] : ['', dateO];
    for (final List<String> row in header) csvdata.write('${ListToCsvConverter(fieldDelimiter: _delimiteri).convert([row])}\r\n');
    await _files[_key('oneFile')]!.writeAsString(csvdata.toString());
    // initialize/reset data buffer
    _buffer[_key('oneFile')] = [];
  }

  /// This method adds a single new data to the buffer and automatically writes buffer into file.
  void logData(DateTime time, List<double>? data, String? deviceId, dynamic key) {
    try {
      _buffer[_key(key, deviceId)]!.add((time, data));
      // if buffer is full, write its content into files
      if (!_dumpInProgress && _buffer.values.any((values) => values.length >= 500)) _dumpBuffer(_delimiteri);
    } catch (e) {
      return;
    }
  }

  String _key(dynamic dataType, [String? deviceUUID]) => _deviceId + dataType.toString();

  /// Closes files and creates a ZIP folder for sharing
  Future<void> endMeasWithShare(bool deleteOriginal) async {
    await closeFiles();
    await downloadFiles(_files.values.toList(), deleteOriginal: deleteOriginal, date: _startTime);
  }

  /// This method dumpes data buffers (i.e. writes the last bit of data to the measurement files).
  /// "Closing" the files in `Dart` is not necessary, as they are not "opened" for writing.
  Future<void> closeFiles() => _dumpBuffer(_delimiteri);

  /// Empty data buffer into files.
  Future<bool> _dumpBuffer(String delimiter) async {
    _dumpInProgress = true;
    try {
      // Copy buffer for it to be quickly cleared for new incoming data async to this current method
      final Map<String, List<(DateTime, List<double>?)>> data = Map<String, List<(DateTime, List<double>?)>>.from(_buffer);
      _buffer.forEach((key, _) => _buffer[key] = []);
      _files.forEach((k, file) async {
        final StringBuffer csvData = StringBuffer();
        for (final (DateTime time, List<double>? data) in data[k]!) {
          if (data != null && data.isNotEmpty) {
            final List<String> dataS = data.map((e) => NumberFormat('#.######', _decimali == ',' ? 'de_DE' : 'en_US').format(e)).toList();
            csvData.write('${ListToCsvConverter(fieldDelimiter: delimiter).convert([
                  [time.dateTime2String(_decimali)] + dataS
                ])}\r\n');
          } else {
            csvData.write('${ListToCsvConverter(fieldDelimiter: delimiter).convert([
                  [time.dateTime2String(_decimali)]
                ])}\r\n');
          }
        }
        await file.writeAsString(csvData.toString(), mode: FileMode.writeOnlyAppend);
      });
      _dumpInProgress = false;
      return true;
    } catch (e) {
      _dumpInProgress = false;
      return false;
    }
  }

  /*static Future<File> cleanUpFile({required BuildContext context, required String file, required MyNumberFormat formatting, String? delimiter, String? decimal}) async {
    late String deli, deci;
    switch (formatting) {
      case MyNumberFormat.de_DE:
        deli = ';';
        deci = ',';
        break;
      case MyNumberFormat.en_US:
        deli = ',';
        deci = '.';
        break;
      case MyNumberFormat.manual:
        if (delimiter == null || decimal == null) throw UnimplementedError();
        deli = delimiter;
        deci = decimal;
        break;
    }
    // read file
    final Map<String, MyLoggedData> data = (await readFile(ReadInput(File(file), MyNumberFormat.manual, deli, deci))).data;
    final String key = data.keys.first; // NOTE: this is a bit dirty ==> only files with a single data stream can be cleaned up
    // write header
    final String dirPath = await getTemporaryDirectory().then((value) => value.path);
    final File compressed = File('$dirPath/ ${file.fileNameWoExt}_compressed.${file.extension}');
    final StringBuffer csvData = StringBuffer();
    for (final List<String> row in data[data.keys.first]!.header) csvData.write('${ListToCsvConverter(fieldDelimiter: deli).convert([row])}\r\n');
    await compressed.writeAsString(csvData.toString());
    // write first data point
    final String firstDataPoint = '${ListToCsvConverter(fieldDelimiter: deli).convert([
          [dateTime2String(data[key]!.time[0], deci), double2String(data[key]!.data[0], deci)]
        ])}\r\n';
    await compressed.writeAsString(firstDataPoint, mode: FileMode.writeOnlyAppend);
    // write the rest
    csvData.clear();
    int marker = 0;
    for (int i = 1; i < data[key]!.data.length; i++)
      // if value is different from previous one or this is the last value
      if (data[key]!.data[i] != data[key]!.data[i - 1] || i == data[key]!.data.length - 1) {
        if (i > marker + 1)
          csvData.write('$csvData${ListToCsvConverter(fieldDelimiter: deli).convert([
                [dateTime2String(data[key]!.time[i - 1], deci), double2String(data[key]!.data[i - 1], deci)]
              ])}\r\n');
        csvData.write('$csvData${ListToCsvConverter(fieldDelimiter: deli).convert([
              [dateTime2String(data[key]!.time[i], deci), double2String(data[key]!.data[i], deci)]
            ])}\r\n');
        marker = i;
      }
    await compressed.writeAsString(csvData.toString(), mode: FileMode.writeOnlyAppend);
    return compressed;
  }*/
}
