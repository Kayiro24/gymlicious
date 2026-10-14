import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';

enum QuoteCategory {
  gym,
  anime;

  static QuoteCategory? tryParse(String? name) => values.asNameMap()[name];
}

/// [id] is the normalised text hash, so the same line from two sources
/// dedupes. Bundled quotes have no author.
@freezed
abstract class Quote with _$Quote {
  const factory({
    required String id,
    required String text,
    required QuoteCategory category,
    required String provider,
    String? author,
    String? sourceTitle,
    DateTime? fetchedAt,
  }) = _Quote;
}
