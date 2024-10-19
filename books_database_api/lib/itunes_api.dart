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

Future<List<AudiobookTunes>?> queryiTunes(
  String term, {
  int limit = 10,
}) async {
  const String baseUrl = 'itunes.apple.com';
  try {
    final Uri songRequest = Uri.https(
      baseUrl,
      'search',
      <String, String>{
        'term': term,
        'media': 'audiobook',
        'limit': '$limit',
      },
    );
    final http.Response response = await http.get(songRequest);
    if (response.statusCode != 200) {
      print('iTunes did not respond with status code 200. (URL: $songRequest) Response body was: ${response.body}');
      return [];
    }
    final List<dynamic>? list = json.decode(response.body)['results'] as List<dynamic>?;
    if (list == null || list.isEmpty) return [];
    final List<AudiobookTunes> songs = <AudiobookTunes>[];
    for (final Map<String, dynamic> e in list) {
      songs.add(AudiobookTunes.fromJson(e));
    }
    return songs;
  } catch (e) {
    rethrow;
  }
}

Future<AudiobookTunes?> queryiTunesSingle({
  required String writer,
  required String title,
}) async {
  String query = title;
  if (title.split(' ').length >= 5) query = title.split(' ').sublist(0, 5).join(' ');
  final List<AudiobookTunes>? result = await queryiTunes(query);
  if (result == null || result.isEmpty) return null;
  return result.firstWhere((e) => e.artist.toLowerCase() == writer.toLowerCase(), orElse: () => result.first);
}
