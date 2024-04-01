import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';

Future<void> extractArchive(String zipFile, String extractTo) async {
  final Uint8List bytes = File(zipFile).readAsBytesSync();
  final Archive archive = ZipDecoder().decodeBytes(bytes);
  for (final ArchiveFile file in archive) {
    final String filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File('$extractTo/$filename')
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      await Directory(extractTo + filename).create(recursive: true);
    }
  }
}
