import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/settings/settings_domain.dart';

abstract final class QuotePool {
  /// Quotes eligible for [mode]: Gym is bundled only; Anime is cached anime,
  /// falling back to bundled; Mix is both; Off is nothing.
  static List<Quote> forMode(
    QuoteMode mode, {
    required List<Quote> bundled,
    required List<Quote> cached,
  }) {
    final anime = [
      for (final quote in cached)
        if (quote.category == QuoteCategory.anime) quote,
    ];
    return switch (mode) {
      QuoteMode.off => const [],
      QuoteMode.gym => bundled,
      QuoteMode.anime => anime.isEmpty ? bundled : anime,
      QuoteMode.mix => [...bundled, ...cached],
    };
  }

  /// Whether [mode] can use online quotes at all.
  static bool usesOnlineSources(QuoteMode mode) =>
      mode == QuoteMode.anime || mode == QuoteMode.mix;
}
