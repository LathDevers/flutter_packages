import 'package:books_database_api/itunes_api.dart';
import 'package:books_database_api/l10n/app_localizations.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class _ITunesGenre {
  static ({List<String> keys, IconData icon}) get ya => (keys: ['kid', 'young'], icon: AdaptiveIcons.child_care_rounded);
  static ({List<String> keys, IconData icon}) get sciFi => (keys: ['sci-fi', 'space'], icon: AdaptiveIcons.rocket);
  static ({List<String> keys, IconData icon}) get romance => (keys: ['romance'], icon: AdaptiveIcons.heart);
  static ({List<String> keys, IconData? icon}) get nonfiction => (keys: ['nonfiction'], icon: null);
  static ({List<String> keys, IconData icon}) get fiction => (keys: ['fiction', 'fantas'], icon: AdaptiveIcons.magic);
  static ({List<String> keys, IconData icon}) get horror => (keys: ['horror', 'thriller'], icon: AdaptiveIcons.ghost);
  static ({List<String> keys, IconData icon}) get mystery => (keys: ['myster', 'crime'], icon: AdaptiveIcons.search);
  static ({List<String> keys, IconData icon}) get science => (keys: ['science', 'physic'], icon: AdaptiveIcons.atom);
  static ({List<String> keys, IconData icon}) get biography => (keys: ['biograph', 'memoir', 'poetr', 'classic'], icon: AdaptiveIcons.feather);
  static ({List<String> keys, IconData icon}) get religion => (keys: ['religion', 'spiritualit'], icon: AdaptiveIcons.pray);
  static ({List<String> keys, IconData icon}) get action => (keys: ['action'], icon: AdaptiveIcons.racing);
  static ({List<String> keys, IconData icon}) get adventure => (keys: ['adventure'], icon: AdaptiveIcons.binoculars);
  static ({List<String> keys, IconData icon}) get arts => (keys: ['art'], icon: AdaptiveIcons.arts);
  static ({List<String> keys, IconData? icon}) get comedy => (keys: ['comed', 'entertainment'], icon: AdaptiveIcons.entertainment);
  static ({List<String> keys, IconData icon}) get tragedy => (keys: ['traged', 'drama'], icon: AdaptiveIcons.tragedy);

  static List<({List<String> keys, IconData? icon})> get all => [
        _ITunesGenre.ya,
        _ITunesGenre.sciFi,
        _ITunesGenre.romance,
        _ITunesGenre.nonfiction,
        _ITunesGenre.fiction,
        _ITunesGenre.horror,
        _ITunesGenre.mystery,
        _ITunesGenre.science,
        _ITunesGenre.biography,
        _ITunesGenre.religion,
        _ITunesGenre.action,
        _ITunesGenre.adventure,
        _ITunesGenre.arts,
        _ITunesGenre.comedy,
        _ITunesGenre.tragedy,
      ];
}

IconData? _genreIcon(String key) {
  for (final ({List<String> keys, IconData? icon}) genre in _ITunesGenre.all) {
    if (genre.keys.any((k) => key.toLowerCase().contains(k.toLowerCase()))) return genre.icon;
  }
  return null;
}

class QueryResultWidget extends StatelessWidget {
  const QueryResultWidget({
    super.key,
    this.locale = 'en',
    required this.queryResult,
  });

  final String locale;
  final AudiobookTunes queryResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (queryResult.coverUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  queryResult.coverUrl!,
                  height: 100,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      queryResult.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('${PackageLocalizations(locale).by} ${queryResult.artist}'),
                    if (queryResult.genre != null)
                      MyChip(
                        iconData: _genreIcon(queryResult.genre!),
                        label: queryResult.genre!,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (queryResult.description != null)
          SizedBox(
            width: double.maxFinite,
            height: 200,
            child: SingleChildScrollView(
              child: Html(
                data: queryResult.description,
                shrinkWrap: true,
              ),
            ),
          ),
      ],
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.label,
    this.iconData,
  });

  final String label;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 3, 12, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null)
              Icon(
                iconData,
                color: Theme.of(context).cardColor,
              ),
            SizedBox(width: iconData != null ? 5 : 9),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    final List<String> stars = [];
    final int fullStars = rating.round();
    for (int i = 0; i < fullStars; i++) stars.add('\u2605');
    for (int i = 0; i < (5 - fullStars); i++) stars.add('\u2606');
    return Text(stars.join());
  }
}
