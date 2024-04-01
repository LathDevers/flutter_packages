import 'dart:io';
import 'package:audio_handler/audio_handler.dart';
import 'package:datatype_extensions/string_extensions.dart';
import 'package:file_manager/get_application_directory.dart';
import 'package:flutter/services.dart';
import 'package:id3tag/id3tag.dart';
import 'package:media_info/media_info.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/media_information.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

String get _stockCover => 'assets/stock_cover.png';

class Metadata {
  const Metadata({
    this.title = 'Unknown',
    this.artist = 'Unknown',
    this.album = 'Unknown',
    required this.cover,
    required this.path,
  });

  final String title;
  final String artist;
  final String album;
  final Uint8List cover;
  final String path;
}

class Mp3Meta {
  const Mp3Meta.asset(this.path)
      : _type = FileTypes.asset,
        directory = null;
  const Mp3Meta.fileInApplicationDirectory(this.path)
      : _type = FileTypes.fileInApplicationDirectory,
        directory = null;
  const Mp3Meta.fileOnStorage(
    this.path, {
    required this.directory,
  }) : _type = FileTypes.fileOnStorage;

  final String path;
  final String? directory;
  final FileTypes _type;

  Future<Metadata?> getMeta() async {
    switch (_type) {
      case FileTypes.fileInApplicationDirectory:
        if (!File(path).existsSync()) return null;
        final ID3TagReader parser = ID3TagReader.path(path);
        final ID3Tag id3tags = parser.readTagSync();
        return Metadata(
          title: id3tags.title ?? 'Unknown',
          artist: id3tags.artist ?? 'Unknown',
          album: id3tags.album ?? 'Unknown',
          cover: await _cover(id3tags.pictures),
          path: path,
        );
      case FileTypes.asset:
        ByteData data;
        try {
          data = await rootBundle.load(path);
        } catch (_) {
          throw Exception('Asset file $path does not exist');
        }
        final String filePath = '${(await getTemporaryDirectory()).path}/${path.fileNameWithExtension}';
        File(filePath).writeAsBytesSync(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        final ID3TagReader parser = ID3TagReader(File(filePath));
        final ID3Tag id3tags = parser.readTagSync();
        return Metadata(
          title: id3tags.title ?? 'Unknown',
          artist: id3tags.artist ?? 'Unknown',
          album: id3tags.album ?? 'Unknown',
          cover: await _cover(id3tags.pictures),
          path: filePath,
        );
      case FileTypes.fileOnStorage:
        final String dirPath = (await getApplicationDocumentsDirectorySub(directory)).path;
        final String newPath = '$dirPath/${basename(path)}';
        if (!File(path).existsSync()) return null;
        await File(path).copy(newPath);
        return Mp3Meta.fileInApplicationDirectory(newPath).getMeta();
    }
  }

  Future<Uint8List> _cover(List<Picture> pictures) async {
    if (pictures.isNotEmpty) {
      try {
        final Picture picture = pictures.firstWhere((picture) => picture.imageData.isNotEmpty);
        return Uint8List.fromList(picture.imageData);
      } on StateError {
        return (await rootBundle.load(_stockCover)).buffer.asUint8List();
      }
    }
    return (await rootBundle.load(_stockCover)).buffer.asUint8List();
  }

  static Future<Uint8List?> cover(String path) async {
    ID3Tag? id3tags;
    if (File(path).existsSync()) {
      final ID3TagReader parser = ID3TagReader.path(path);
      id3tags = parser.readTagSync();
    }
    final Uint8List? cover = (id3tags == null || id3tags.pictures.isEmpty) ? null : Uint8List.fromList(id3tags.pictures.first.imageData);
    return cover;
  }

  static Future<Duration> getDuration(String path) async {
    ID3Tag? id3tags;
    if (File(path).existsSync()) {
      final ID3TagReader parser = ID3TagReader.path(path);
      id3tags = parser.readTagSync();
    }
    if (id3tags?.duration != null) return id3tags!.duration!;
    final Duration? duration = await _getDurationFFprobe(path);
    if (duration != null) return duration;
    try {
      final Map<String, dynamic> mediaInfo = await MediaInfo().getMediaInfo(path).timeout(const Duration(seconds: 3));
      return Duration(milliseconds: mediaInfo['durationMs'] as int);
    } catch (_) {
      return Duration.zero;
    }
  }

  static Future<Duration?> _getDurationFFprobe(String path) async {
    try {
      final MediaInformationSession mediaInfoSession = await FFprobeKit.getMediaInformation(path).timeout(const Duration(milliseconds: 1500));
      final MediaInformation? mediaInfo = mediaInfoSession.getMediaInformation();
      if (mediaInfo == null || mediaInfo.getDuration() == null) return null;
      final double duration = double.parse(mediaInfo.getDuration()!);
      final Duration result = Duration(microseconds: (duration * 1e6).round());
      return result;
    } catch (_) {
      return null;
    }
  }
}
