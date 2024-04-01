import 'dart:io';

/// Deletes [files].
/// Returns an empty list, if every file was deleted successfully.
/// Returns the files that cannot be deleted.
Future<List<File>> deleteFiles(List<File> files) async {
  final List<File> cannotDelete = [];
  for (final File file in files) {
    try {
      await file.delete();
    } on Exception catch (e) {
      print(e);
      cannotDelete.add(file);
    }
  }
  return cannotDelete;
}
