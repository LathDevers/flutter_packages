import 'package:books_database_api/google_books_api.dart';
import 'package:books_database_api/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueryResultWidget extends StatelessWidget {
  const QueryResultWidget({
    super.key,
    this.locale = 'en',
    required this.queryResult,
  });

  final String locale;
  final Book queryResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                queryResult.info.imageLinks['smallThumbnail'].toString(),
                height: 100,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(queryResult.info.title),
                    if (queryResult.info.subtitle.isNotEmpty) Text(queryResult.info.subtitle),
                    GoogleBookMeta(
                      title: PackageLocalizations(locale).writer(queryResult.info.authors.length),
                      value: queryResult.info.authors.join(', '),
                    ),
                    GoogleBookMeta(
                      title: PackageLocalizations(locale).publisher,
                      value: queryResult.info.publisher,
                    ),
                    GoogleBookMeta(
                      title: PackageLocalizations(locale).publishedOn,
                      value: queryResult.info.rawPublishedDate,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GoogleBookMeta(
                          title: PackageLocalizations(locale).rating,
                          value: queryResult.info.averageRating == 0 ? '-' : NumberFormat('0.0', locale).format(queryResult.info.averageRating),
                        ),
                        if (queryResult.info.averageRating != 0) ...[
                          const SizedBox(width: 5),
                          RatingStars(rating: queryResult.info.averageRating),
                        ],
                      ],
                    ),
                    GoogleBookMeta(
                      title: PackageLocalizations(locale).category,
                      value: queryResult.info.categories.join(', '),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(PackageLocalizations(queryResult.info.language).flagImagePath, height: 30),
          ],
        ),
        Text(
          queryResult.info.description,
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}

class GoogleBookMeta extends StatelessWidget {
  const GoogleBookMeta({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 12),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
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
