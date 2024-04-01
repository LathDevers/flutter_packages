import 'dart:io';

enum MyDirectory { temporary, documents }

// ignore: constant_identifier_names
enum MyNumberFormat { de_DE, en_US, manual }

class MyError {
  const MyError({this.row, required this.code, this.comment});

  const MyError.fromComment(this.comment)
      : row = null,
        code = 0;

  final int? row;
  final int code;
  final String? comment;
}

Map<int, String> errorCodes = {
  1000: 'Time stamp is in the past',
  500: 'Exception',
  501: 'Timeout',
  1500: 'File is empty',
  1501: 'Header not found',
  1502: 'No data found in file',
};

class MyResult {
  const MyResult({
    required this.errors,
    required this.header,
    required this.data,
  });

  final List<MyError> errors;
  final List<List<String>> header;
  final List<({DateTime time, double elapsedTime, List<String> row})> data;
}

/// Flutter's own [FileSystemEntity] doesn't provide special information that is needed in [LogData].
/// So [MyFileSystemEntity] can be used to store vital info of a file system entity, that can either
/// be a [File] or a [Directory].
class MyFileSystemEntity {
  const MyFileSystemEntity({
    required this.fileName,
    required this.fileNameWithExtension,
    required this.type,
    required this.path,
  });

  /// A [String] containing the file system entity's name, without the extension if entity has an extension.
  final String fileName;

  final String fileNameWithExtension;

  /// A [String] containing the file system entity's type.
  ///
  /// This can either be the `<file extension>` or `?` if entity is not a folder, but has no extension.
  /// If entity is a folder then `dir`.
  final String type;

  /// A [String] containing the file system entity's full path.
  final String path;
}

class MyLoggedData {
  const MyLoggedData({
    required this.header,
    required this.time,
    required this.elapsedTime,
    required this.data,
  });

  final List<List<String>> header;
  final List<DateTime> time;
  final List<double> elapsedTime;
  final List<double> data;

  static MyLoggedData empty = const MyLoggedData(
    header: [[]],
    time: [],
    elapsedTime: [],
    data: [],
  );
}

class ReadInput {
  const ReadInput(this.file, this.formatting, [this.delimiter, this.decimal]);

  final File file;
  final MyNumberFormat formatting;
  final String? delimiter;
  final String? decimal;
}

class MyLoggedDataWrapped {
  const MyLoggedDataWrapped({
    required this.data,
    required this.errors,
  });

  final Map<String, MyLoggedData> data;
  final List<MyError> errors;
}
