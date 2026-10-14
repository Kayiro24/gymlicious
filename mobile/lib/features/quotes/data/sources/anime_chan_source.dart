import 'package:dio/dio.dart';
import 'package:gym_tracker/core/failure/failure.dart';
import 'package:gym_tracker/core/failure/result.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_source.dart';
import 'package:gym_tracker/features/quotes/domain/quote_validator.dart';

/// AnimeChan random quote (key-less). See docs/quote-providers.md.
class AnimeChanSource implements QuoteSource {
  const new(this.dio);

  static const sourceId = 'animechan';
  static const randomQuoteUrl = 'https://api.animechan.io/v1/quotes/random';

  final Dio dio;

  @override
  String get id => sourceId;

  @override
  QuoteCategory get category => QuoteCategory.anime;

  @override
  int get maxRequestsPerHour => 3;

  @override
  Future<Result<List<Quote>>> fetch(DateTime now) async {
    final Response<Object?> response;
    try {
      response = await dio.get<Object?>(randomQuoteUrl);
    } on DioException catch (error) {
      return Err(
        NetworkFailure(
          error.message ?? error.type.name,
          isRateLimited: error.response?.statusCode == 429,
        ),
      );
    }
    final body = response.data;
    final data = body is Map<String, dynamic> ? body['data'] : null;
    if (data is! Map<String, dynamic> || data['content'] is! String) {
      return const Err(NetworkFailure('Unexpected AnimeChan payload'));
    }
    final quote = QuoteValidator.validate(
      text: data['content'] as String,
      author: _name(data['character']),
      sourceTitle: _name(data['anime']),
      category: category,
      provider: id,
      fetchedAt: now,
    );
    return Ok([?quote]);
  }

  static String? _name(Object? value) =>
      value is Map<String, dynamic> && value['name'] is String
      ? value['name'] as String
      : null;
}
