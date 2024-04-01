import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_manager/delete_files.dart';
import 'package:file_manager/extensions.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast_message.dart';

/// Encodes `filesToEncode` into a ZIP folder and shares it
Future<bool> shareFiles(List<File> filesToEncode, bool deleteOriginal, DateTime date, [String? userName]) async {
  if (filesToEncode.isEmpty) {
    print('No files were passed to share');
    return false;
  }
  if (filesToEncode.length == 1) {
    bool result = true;
    try {
      // share file
      final ShareResult shareResult = await Share.shareXFiles([XFile(filesToEncode.first.path)]);
      if (shareResult.status == ShareResultStatus.dismissed) result = false;
      if (shareResult.status == ShareResultStatus.unavailable) result = false;
      // delete all the files
      await Future.delayed(const Duration(seconds: 2));
      if (deleteOriginal) for (final File file in filesToEncode) await file.delete();
    } catch (_) {
      result = false;
    }
    return result;
  }
  bool result = true;
  try {
    // compress files
    late String zipPath;
    final String dirPath = await getTemporaryDirectory().then((value) => value.path);
    final String dateString = DateFormat('yyyyMMdd_kkmmss').format(date);
    zipPath = userName.isUsername ? '$dirPath/${dateString}_Measurement_$userName.zip' : '$dirPath/${dateString}_Measurement.zip';
    final ZipFileEncoder encoder = ZipFileEncoder()..create(zipPath);
    for (final File file in filesToEncode) await encoder.addFile(file);
    encoder.close();
    // share compressed zip file
    final ShareResult shareResult = await Share.shareXFiles([XFile(zipPath)]);
    if (shareResult.status == ShareResultStatus.dismissed) result = false;
    if (shareResult.status == ShareResultStatus.unavailable) result = false;
    // delete all the files
    await Future.delayed(const Duration(seconds: 2));
    if (deleteOriginal) for (final File file in filesToEncode) await file.delete();
    await File(zipPath).delete();
  } catch (_) {
    result = false;
  }
  return result;
}

/// On Android, this method downloads `filesToEncode` into the Downloads folder.
/// On iOS, this method shares `filesToEncode` via the share sheet.
///
/// If `filesToEncode` is only one file, it is copied directly.
/// If `filesToEncode` is more than one file, they are compressed into a ZIP folder.
///
/// If `deleteOriginal` is true, the original files are deleted after copying.
/// `date` is used to name the ZIP folder.
///
/// Returns `true` if the operation was successful, `false` otherwise. May throw an exception, that is however overridden in release mode.
Future<bool> downloadFiles(List<File> filesToEncode, [bool deleteOriginal = false, DateTime? date, String? userName]) async {
  // Unable to save to Downloads folder on iOS
  if (Platform.isIOS) return shareFiles(filesToEncode, deleteOriginal, date ?? DateTime.now());
  // else (on Android) download to Downloads folder
  bool result = true;
  date ??= DateTime.now();

  /// Get directory paths
  final String tempDir = (await getTemporaryDirectory()).path;
  final String? dirPath = _getDownloadsFolder();
  if (dirPath == null) {
    // if no Downloads folder found, use sharing
    print('No Downloads folder found');
    return shareFiles(filesToEncode, deleteOriginal, date);
  }

  /// Do copy or zip
  if (filesToEncode.isEmpty) {
    // No files were provided
    print('No files were passed to download');
    return false;
  }
  if (filesToEncode.length == 1) {
    // Copy one file to Download folder
    final String fileName = filesToEncode.first.path.fileNameWithExtension;
    result = await _copy(filesToEncode.first, File('$dirPath/$fileName'));
    if (result) {
      unawaited(MyToast.showToast(message: 'Downloaded $fileName to Downloads folder'));
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      result = await shareFiles(filesToEncode, deleteOriginal, date);
    }
    if (deleteOriginal) await deleteFiles(filesToEncode);
    return result;
  }
  if (filesToEncode.length > 1) {
    // Compress files
    final String dateString = DateFormat('yyyyMMdd_kkmmss').format(date);
    final String zipName = userName.isUsername ? '${dateString}_Measurement_$userName.zip' : '${dateString}_Measurement.zip';
    final String zipPath = '$tempDir/$zipName';
    await _compressFiles(zipPath, filesToEncode);
    result = await _copy(File(zipPath), File('$dirPath/$zipName'));
    if (result) {
      unawaited(MyToast.showToast(message: 'Downloaded $zipName to Downloads folder'));
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      result = await shareFiles(filesToEncode, deleteOriginal, date);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (deleteOriginal) await deleteFiles(filesToEncode);
    await File(zipPath).delete();
    return result;
  }
  print('If the code made it this far, the developer made some mistake');
  return false;
}

String? _getDownloadsFolder() {
  const String downloads = '/storage/emulated/0/Downloads';
  if (Directory(downloads).existsSync()) return downloads;
  const String download = '/storage/emulated/0/Download';
  if (Directory(download).existsSync()) return download;
  return null;
}

Future<bool> _copy(File original, File copy) async {
  bool result = true;
  try {
    await original.copy(copy.path).timeout(const Duration(milliseconds: 1000), onTimeout: () {
      result = false;
      return original;
    });
  } catch (e) {
    print(e);
    result = false;
  }
  return result;
}

Future<File> _compressFiles(String path, List<File> files) async {
  final ZipFileEncoder encoder = ZipFileEncoder()..create(path);
  for (final File file in files) await encoder.addFile(file);
  encoder.close();
  return File(path);
}
