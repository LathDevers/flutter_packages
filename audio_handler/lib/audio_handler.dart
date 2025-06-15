import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_handler/mp3_meta.dart';
import 'package:audio_session/audio_session.dart';
import 'package:datatype_extensions/string_extensions.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FileTypes { fileOnStorage, asset, fileInApplicationDirectory }

class StoredData {
  const StoredData({
    required this.path,
    required this.type,
    required this.audioSource,
    required this.meta,
  });

  final String path;
  final FileTypes type;
  final AudioSource audioSource;
  final Metadata meta;
}

/// Wrapper for the Flutter package `just_audio` with initialization, play-pause functionality
/// and playlist management.
class MusicPlayer {
  static Future<void> init() async {
    return JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true,
    );
  }

  final _myPlayer = AudioPlayer();
  late AudioSession _session;
  final List<StoredData> _playlist = <StoredData>[];

  List<StoredData> get playlist => _playlist;

  set playlist(List<StoredData> value) {
    _playlist
      ..clear()
      ..addAll(value);
  }

  Stream<int?> get currentIndexStream => _myPlayer.currentIndexStream;
  Stream<Duration> get positionStream => _myPlayer.positionStream;
  Stream<Duration> get bufferedPositionStream => _myPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _myPlayer.durationStream;
  int? get currentIndex => _myPlayer.currentIndex;
  bool get playing => _myPlayer.playing;

  Uint8List? get currentImage {
    if (currentIndex == null) return null;
    return _playlist[currentIndex!].meta.cover;
  }

  /// Inform the operating system of audio attributes. Configure [AudioSession], set mode and set [AudioSource].
  Future<void> initialize() async {
    _session = await AudioSession.instance;
    await _session.configure(const AudioSessionConfiguration.music()).timeout(const Duration(seconds: 3));
    await _session.setActive(true);
    // Listen for if the user unplugged the headphones.
    _session.becomingNoisyEventStream.listen((_) => _myPlayer.pause());
    // Listen to errors during playback.
    _myPlayer.playbackEventStream.listen((_) {}, onError: (Object e, StackTrace stackTrace) => print('A stream error occurred: $e'));
    await _myPlayer.setLoopMode(LoopMode.all);
    try {
      await _myPlayer.setAudioSources(_playlist.map((e) => e.audioSource).toList()).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
    }
  }

  /// Release resources back to the operating system making them available for other apps to use.
  Future<void> dispose() async {
    await _session.setActive(false);
    await _myPlayer.stop();
    await _myPlayer.dispose();
    playlist = <StoredData>[];
  }

  /// Return play-pause button that listens to [_myPlayer].
  Widget buildPlayPauseButton(Widget iconIfPlaying, Widget iconIfPaused) {
    return StreamBuilder<PlayerState>(
      stream: _myPlayer.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.data?.playing != true) {
          return IconButton(
            icon: iconIfPlaying,
            padding: EdgeInsets.zero,
            onPressed: _myPlayer.play,
          );
        } else if (snapshot.data?.processingState != ProcessingState.completed) {
          return IconButton(
            icon: iconIfPaused,
            padding: EdgeInsets.zero,
            onPressed: _myPlayer.pause,
          );
        } else {
          return IconButton(
            icon: Icon(
              AdaptiveIcons.replay,
              color: Colors.white,
              size: 80 - 4 * 8,
            ),
            padding: EdgeInsets.zero,
            onPressed: () async => _myPlayer.setAudioSources(_playlist.map((e) => e.audioSource).toList()),
          );
        }
      },
    );
  }

  Future<void> seekToPrevious() => _myPlayer.seekToPrevious().then((_) => _myPlayer.play());

  Future<void> seekToNext() => _myPlayer.seekToNext().then((_) => _myPlayer.play());

  Future<void> seekToIndex(int index) => _myPlayer.seek(Duration.zero, index: index).then((_) => _myPlayer.play());

  /// If input is less than 0, speed is set to 1.
  Future<void> setPlaybackSpeed(double speed) async {
    if (_myPlayer.speed == speed) return;
    if (speed < 0) speed = 1;
    await _myPlayer.setSpeed(speed);
  }

  List<Metadata> getPlaylistMeta() => _playlist.map((e) => e.meta).toList();

  Future<List<StoredData>?> openSongPicker() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
        allowMultiple: true,
      );
      if (result != null) {
        final List<StoredData> newSongs = <StoredData>[];
        for (final PlatformFile file in result.files) {
          final StoredData? newSong = await addNewSong(file.path!, FileTypes.fileOnStorage, file == result.files.last);
          if (newSong != null) newSongs.add(newSong);
        }
        return newSongs;
      }
    } on PlatformException catch (e) {
      print('Unsupported operation $e');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<StoredData?> addNewSong(String path, FileTypes fileType, bool setPlaylist) async {
    if (_myPlayer.playing) await _myPlayer.pause();
    // read meta data
    final Metadata? id3tags = switch (fileType) {
      FileTypes.fileOnStorage => await Mp3Meta.fileOnStorage(path, directory: 'SonicCoach').getMeta(),
      FileTypes.asset => await Mp3Meta.asset(path).getMeta(),
      FileTypes.fileInApplicationDirectory => await Mp3Meta.fileInApplicationDirectory(path).getMeta(),
    };
    if (id3tags == null) return null;
    final String l = _playlist.isEmpty ? '0' : _playlist.length.toString();
    late Uri artUri;
    StoredData? storedData;
    final String imageTempPath = '${(await getTemporaryDirectory()).path}/${path.fileNameWoExt}.jpg';
    File(imageTempPath).writeAsBytesSync(id3tags.cover);
    artUri = Uri.file(imageTempPath);
    storedData = StoredData(
      path: path,
      type: fileType,
      audioSource: AudioSource.file(
        id3tags.path,
        tag: MediaItem(
          id: l,
          title: id3tags.title,
          artist: id3tags.artist,
          album: id3tags.album,
          artUri: artUri,
        ),
      ),
      meta: id3tags,
    );
    _playlist.add(storedData);
    if (setPlaylist)
      try {
        await _myPlayer.addAudioSource(storedData.audioSource);
      } on PlayerException catch (e) {
        // iOS/macOS: maps to NSError.code
        // Android: maps to ExoPlayerException.type
        // Web: maps to MediaError.code
        print('Error code: ${e.code}');
        // iOS/macOS: maps to NSError.localizedDescription
        // Android: maps to ExoPlaybackException.getMessage()
        // Web: a generic message
        print('Error message: ${e.message}');
      } on PlayerInterruptedException catch (e) {
        // This call was interrupted since another audio source was loaded or the
        // player was stopped or disposed before this audio source could complete
        // loading.
        print('Connection aborted: ${e.message}');
      } catch (e) {
        // Fallback for all errors
        print(e);
      }
    return storedData;
  }

  Future<void> removeAtIndex(int index) async {
    await _myPlayer.pause();
    _playlist.removeAt(index);
    // set playlist
    await _myPlayer.removeAudioSourceAt(index);
  }

  ({String title, String artist, Uint8List cover, int index}) getCurrentSongData() {
    if (currentIndex != null && _playlist.isNotEmpty) {
      return (
        title: _playlist[currentIndex!].meta.title,
        artist: _playlist[currentIndex!].meta.artist,
        cover: _playlist[currentIndex!].meta.cover,
        index: currentIndex!,
      );
    } else {
      return (title: 'Title', artist: 'Artist', cover: Uint8List.fromList([]), index: 0);
    }
  }

  Future<void> savePlaylistSharedPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${key}paths', _playlist.map((e) => e.path).toList());
    await prefs.setStringList('${key}types', _playlist.map((e) => e.type.name).toList());
  }

  Future<void> getPlaylistSharedPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> paths = prefs.getStringList('${key}paths') ?? List<String>.empty();
    final List<String> types = prefs.getStringList('${key}types') ?? List<String>.empty();
    if (paths.isEmpty) return;
    if (types.isEmpty) return;
    if (paths.length != types.length) return;
    for (int i = 0; i < paths.length; i++) {
      if (paths[i] == '' || types[i] == '') return;
      await addNewSong(paths[i], _string2FileType(types[i]), i == paths.length - 1);
    }
  }

  FileTypes _string2FileType(String type) {
    switch (type) {
      case 'fileOnStorage':
        return FileTypes.fileOnStorage;
      case 'asset':
        return FileTypes.asset;
      case 'fileInApplicationDirectory':
        return FileTypes.fileInApplicationDirectory;
      default:
        return FileTypes.asset;
    }
  }
}

class SeekBar extends StatefulWidget {
  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.showRemainingTime = true,
    this.showThumb = true,
    this.positionColor = const Color(0xffff091c),
    this.bufferedColor = const Color(0xffFFCDD2),
    this.remainingTrackColor = const Color(0xffE0E0E0),
    this.height = 1,
  });

  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final bool showRemainingTime;
  final bool showThumb;
  final Color positionColor;
  final Color bufferedColor;
  final Color remainingTrackColor;
  final double height;

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? dragValue;
  late SliderThemeData sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2,
      trackShape: const RectangularSliderTrackShape(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: sliderThemeData.copyWith(
            thumbShape: SliderComponentShape.noThumb,
            activeTrackColor: widget.bufferedColor,
            inactiveTrackColor: widget.remainingTrackColor,
            trackHeight: widget.height,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() => dragValue = value);
                widget.onChanged?.call(Duration(milliseconds: value.round()));
              },
              onChangeEnd: (value) {
                widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
                dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: sliderThemeData.copyWith(
            thumbShape: widget.showThumb ? null : SliderComponentShape.noThumb,
            thumbColor: widget.positionColor,
            activeTrackColor: widget.positionColor,
            inactiveTrackColor: Colors.transparent,
            trackHeight: widget.height,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(dragValue ?? widget.position.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() => dragValue = value);
              widget.onChanged?.call(Duration(milliseconds: value.round()));
            },
            onChangeEnd: (value) {
              widget.onChangeEnd?.call(Duration(milliseconds: value.round()));
              dragValue = null;
            },
          ),
        ),
        if (widget.showRemainingTime)
          Positioned(
            right: 16.0,
            bottom: 0.0,
            child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$remaining')?.group(1) ?? '$remaining', style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }

  Duration get remaining => widget.duration - widget.position;
}
