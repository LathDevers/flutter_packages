import 'package:platform_adaptivity/adaptive_widgets.dart';

extension StringExtension on String {
  /// Returns the base of `this`.
  ///
  /// ```dart
  /// 'path/to/file.txt'.fileNameWithExtension; // 'file.txt'
  /// ```
  String get fileNameWithExtension {
    final List<String> pathParts = split('/');
    final String fileName = pathParts.removeLast();
    return fileName;
  }

  /// Returns the base of `this` without the extension part.
  ///
  /// ```dart
  /// 'path/to/file.txt'.fileNameWoExt; // 'file'
  /// ```
  String get fileNameWoExt {
    final List<String> pathParts = split('/');
    final String fileName = pathParts.removeLast();
    final List<String> fileNameParts = fileName.split('.');
    final String fileNameWoExt = fileNameParts.join('.');
    return fileNameWoExt;
  }

  /// Returns the extension of `this`.
  ///
  /// ```dart
  /// 'path/to/file.txt'.extension; // 'txt'
  /// ```
  String get extension {
    final List<String> pathParts = split('/');
    final String fileName = pathParts.removeLast();
    final List<String> fileNameParts = fileName.split('.');
    final String extension = fileNameParts.removeLast();
    return extension;
  }

  /// In title-style capitalization, capitalize every word except:
  ///
  /// - Articles (a, an, the)
  /// - Coordinating conjunctions (and, or)
  /// - Prepositions of four or fewer letters, except when the preposition is part of a verb phrase, as in “Starting Up the Computer”
  ///
  /// In title style, always capitalize the first and last word, even if it is an article, a conjunction, or a preposition of four or fewer letters.
  ///
  /// *Source: Apple developer design guidelines*
  String get capitalizeTitleCupertino {
    if (!isCupertino) return this;
    const List<String> blacklistEN = ['a', 'an', 'the', 'and', 'or'];
    const List<String> blacklistDE = ['ein', 'eine', 'der', 'die', 'das', 'den', 'dem', 'des', 'und', 'oder'];
    final List<String> blacklist = [...blacklistEN, ...blacklistDE];
    final StringBuffer result = StringBuffer(this[0].toUpperCase());
    for (int i = 1; i < length; i++) {
      if (this[i - 1] == ' ' && this[i] != ' ' && !blacklist.contains(substring(i).split(' ').first)) {
        result.write(this[i].toUpperCase());
      } else {
        result.write(this[i]);
      }
    }
    return result.toString();
  }

  /// Concatenate [this] with [other]. If [other] is `null`, it returns null.
  String? concatOrNull(String? other) => other == null ? null : this + other;
}
