import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';

/// One online quote provider. Adding a source is one adapter plus one
/// registration; a future backend would implement this too.
abstract interface class QuoteSource {
  String get id;

  QuoteCategory get category;

  /// Requests allowed per rolling hour, kept well under the provider's limit.
  int get maxRequestsPerHour;

  Future<Result<List<Quote>>> fetch(DateTime now);
}
