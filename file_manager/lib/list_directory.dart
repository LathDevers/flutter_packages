import 'dart:io';

import 'package:file_manager/get_application_directory.dart';
import 'package:file_manager/types.dart';

/// Returns a list of entities. Properties of an entity are: name of entity, type of entity and entity's full path.
///
/// Type of entity can be: `<file extension>`, if a folder: `dir` and if not a folder but has no extension: `?`.
Future<List<MyFileSystemEntity>> listFolder({Directory? path, String? appDirSub}) async {
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
