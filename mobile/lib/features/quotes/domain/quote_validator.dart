import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';

/// In-app validation for every fetched quote (spec 6.2 rule 4).
abstract final class QuoteValidator {
  static const maxLength = 200;

  static const _blocklist = {
    'fuck',
    'fucking',
    'shit',
    'bitch',
    'bastard',
    'asshole',
    'cunt',
    'dick',
    'whore',
    'slut',
    'retard',
    'rape',
    'nigger',
    'faggot',
  };

  static final _tags = RegExp('<[^>]*>');
  static final _whitespace = RegExp(r'\s+');
  static final _nonWord = RegExp(r"[^\p{L}\p{N}\s']", unicode: true);
  static final _words = RegExp(r"[\p{L}']+", unicode: true);

  static String clean(String raw) =>
      raw.replaceAll(_tags, ' ').replaceAll(_whitespace, ' ').trim();

  /// Lowercase, punctuation-free, single-spaced text hashed for dedupe.
  static String idFor(String text) {
    final normalised = clean(text)
        .toLowerCase()
        .replaceAll(_nonWord, ' ')
        .replaceAll(_whitespace, ' ')
        .trim();
    return sha256.convert(utf8.encode(normalised)).toString();
  }

  static bool _isClean(String text) => !_words
      .allMatches(text.toLowerCase())
      .any((match) => _blocklist.contains(match.group(0)));

  /// Returns a cleaned quote, or null when it must be rejected.
  static Quote? validate({
    required String text,
    required QuoteCategory category,
    required String provider,
    required DateTime fetchedAt,
    String? author,
    String? sourceTitle,
  }) {
    final cleanText = clean(text);
    final cleanAuthor = author == null ? null : clean(author);
    final cleanSource = sourceTitle == null ? null : clean(sourceTitle);
    if (cleanText.isEmpty || cleanText.length > maxLength) {
      return null;
    }
    final attribution = '$cleanText ${cleanAuthor ?? ''} ${cleanSource ?? ''}';
    if (!_isClean(attribution)) {
      return null;
    }
    return Quote(
      id: idFor(cleanText),
      text: cleanText,
      category: category,
      provider: provider,
      author: cleanAuthor == null || cleanAuthor.isEmpty ? null : cleanAuthor,
      sourceTitle: cleanSource == null || cleanSource.isEmpty
          ? null
          : cleanSource,
      fetchedAt: fetchedAt,
    );
  }
}
