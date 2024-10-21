// https://performance-partners.apple.com/search-api

import 'dart:convert';
import 'package:http/http.dart' as http;

class AudiobookTunes {
  const AudiobookTunes({
    required this.artist,
    required this.title,
    this.coverUrl,
    this.price,
    this.genre,
    this.description,
  });

  static AudiobookTunes fromJson(Map<String, dynamic> json) {
    return AudiobookTunes(
      artist: json['artistName'] ?? 'Unknown',
      title: json['collectionName'] ?? 'Unknown',
      coverUrl: json['artworkUrl100'],
      price: (value: json['collectionPrice'], currency: json['currency']),
      genre: json['primaryGenreName'],
      description: json['description'],
    );
  }

  final String artist;
  final String title;
  final String? coverUrl;
  final ({double value, String currency})? price;
  final String? genre;
  final String? description;
}

Future<List<AudiobookTunes>?> queryiTunes({
  String? writer,
  String? title,
  int limit = 10,
}) async {
  const String baseUrl = 'itunes.apple.com';

  String term = title ?? ' ';
  if ((title?.split(' ').length ?? 0) >= 5) term = title!.split(' ').sublist(0, 5).join(' ');

  try {
    final Uri request = Uri.https(
      baseUrl,
      'search',
      <String, String>{
        'term': term,
        'media': 'audiobook',
        'limit': '$limit',
      },
    );
    final http.Response response = await http.get(request);
    if (response.statusCode != 200) {
      print('iTunes did not respond with status code 200. (URL: $request) Response body was: ${response.body}');
      return null;
    }
    final List<dynamic>? list = json.decode(response.body)['results'] as List<dynamic>?;
    if (list == null || list.isEmpty) return null;
    final List<AudiobookTunes> songs = <AudiobookTunes>[];
    for (final Map<String, dynamic> e in list) {
      songs.add(AudiobookTunes.fromJson(e));
    }
    if (writer != null) {
      final List<AudiobookTunes> result = songs.where((e) => e.artist.toLowerCase() == writer.toLowerCase()).toList();
      if (result.isNotEmpty) return result;
      return null;
    }
    return songs;
  } catch (e) {
    rethrow;
  }
}
