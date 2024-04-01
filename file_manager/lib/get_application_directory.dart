import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Path to a directory where the application may place data that is
/// user-generated, or that cannot otherwise be recreated by your application.
///
/// Consider using another path, such as [getApplicationSupportDirectory] or
/// [getExternalStorageDirectory], if the data is not user-generated.
///
/// Example implementations:
/// - `NSDocumentDirectory` on iOS and macOS.
/// - The Flutter engine's `PathUtils.getDataDirectory` API on Android.
///
/// Throws a [MissingPlatformDirectoryException] if the system is unable to
/// provide the directory.
Future<Directory> getApplicationDocumentsDirectorySub(String? subFolder) async {
  if (subFolder == null) return getApplicationDocumentsDirectory();
  final String path = (await getApplicationDocumentsDirectory()).path;
  final String fullPath = '$path/$subFolder';
  if (!Directory(fullPath).existsSync()) return Directory(fullPath).create();
  return Directory(fullPath);
}
