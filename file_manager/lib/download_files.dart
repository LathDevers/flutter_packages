import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:archive/archive_io.dart';
import 'package:file_manager/delete_files.dart';
import 'package:file_manager/extensions.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast_message.dart';

enum DownloadResult { success, dismissed, unavailable, noFiles, error, copyDownloadFolderError }

/// Encodes `filesToEncode` into a ZIP folder and shares it
Future<DownloadResult> shareFiles(List<File> filesToEncode, {required bool deleteOriginal, required DateTime date, String? userName, Rect? sharePositionOrigin}) async {
  if (filesToEncode.isEmpty) {
    print('No files were passed to share');
    return DownloadResult.noFiles;
  }
  if (filesToEncode.length == 1) {
    DownloadResult result = DownloadResult.success;
    try {
      // share file
      final ShareResult shareResult = await SharePlus.instance.share(ShareParams(
        files: [XFile(filesToEncode.first.path)],
        sharePositionOrigin: sharePositionOrigin,
      ));
      if (shareResult.status == ShareResultStatus.dismissed) result = DownloadResult.dismissed;
      if (shareResult.status == ShareResultStatus.unavailable) result = DownloadResult.unavailable;
      // delete all the files
      if (result == DownloadResult.success) {
        await Future.delayed(const Duration(seconds: 2));
        if (deleteOriginal) for (final File file in filesToEncode) await file.delete();
      }
    } catch (e) {
      print(e);
      result = DownloadResult.error;
    }
    return result;
  }
  DownloadResult result = DownloadResult.success;
  try {
    // compress files
    late String zipPath;
    final String dirPath = await getTemporaryDirectory().then((value) => value.path);
    final String dateString = DateFormat('yyyyMMdd_kkmmss').format(date);
    zipPath = userName.isUsername ? '$dirPath/${dateString}_Measurement_$userName.zip' : '$dirPath/${dateString}_Measurement.zip';
    final ZipFileEncoder encoder = ZipFileEncoder()..create(zipPath);
    for (final File file in filesToEncode) await encoder.addFile(file);
    await encoder.close();
    // share compressed zip file
    final ShareResult shareResult = await SharePlus.instance.share(ShareParams(
      files: [XFile(zipPath)],
      sharePositionOrigin: sharePositionOrigin,
    ));
    if (shareResult.status == ShareResultStatus.dismissed) result = DownloadResult.dismissed;
    if (shareResult.status == ShareResultStatus.unavailable) result = DownloadResult.unavailable;
    // delete all the files
    await Future.delayed(const Duration(seconds: 2));
    if (deleteOriginal) for (final File file in filesToEncode) await file.delete();
    await File(zipPath).delete();
  } catch (e) {
    print(e);
    result = DownloadResult.error;
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
Future<DownloadResult> downloadFiles(List<File> filesToEncode, {bool deleteOriginal = false, DateTime? date, String? userName, Rect? sharePositionOrigin}) async {
  // Unable to save to Downloads folder on iOS
  if (Platform.isIOS)
    return shareFiles(
      filesToEncode,
      deleteOriginal: deleteOriginal,
      date: date ?? DateTime.now(),
      sharePositionOrigin: sharePositionOrigin,
    );
  // else (on Android) download to Downloads folder
  DownloadResult result = DownloadResult.success;
  date ??= DateTime.now();

  /// Get directory paths
  final String tempDir = (await getTemporaryDirectory()).path;
  final String? dirPath = _getDownloadsFolder();
  if (dirPath == null) {
    // if no Downloads folder found, use sharing
    print('No Downloads folder found');
    return shareFiles(
      filesToEncode,
      deleteOriginal: deleteOriginal,
      date: date,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Do copy or zip
  if (filesToEncode.isEmpty) {
    // No files were provided
    print('No files were passed to download');
    return DownloadResult.noFiles;
  }
  if (filesToEncode.length == 1) {
    // Copy one file to Download folder
    final String fileName = filesToEncode.first.path.fileNameWithExtension;
    result = await _copy(filesToEncode.first, File('$dirPath/$fileName')) ? DownloadResult.success : DownloadResult.copyDownloadFolderError;
    if (result == DownloadResult.success) {
      unawaited(MyToast.showToast(message: 'Downloaded $fileName to Downloads folder'));
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      result = await shareFiles(
        filesToEncode,
        deleteOriginal: deleteOriginal,
        date: date,
        sharePositionOrigin: sharePositionOrigin,
      );
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
    result = await _copy(File(zipPath), File('$dirPath/$zipName')) ? DownloadResult.success : DownloadResult.copyDownloadFolderError;
    if (result == DownloadResult.success) {
      unawaited(MyToast.showToast(message: 'Downloaded $zipName to Downloads folder'));
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      result = await shareFiles(
        filesToEncode,
        deleteOriginal: deleteOriginal,
        date: date,
        sharePositionOrigin: sharePositionOrigin,
      );
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (deleteOriginal) await deleteFiles(filesToEncode);
    await File(zipPath).delete();
    return result;
  }
  print('If the code made it this far, the developer made some mistake');
  return DownloadResult.error;
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
  await encoder.close();
  return File(path);
}
