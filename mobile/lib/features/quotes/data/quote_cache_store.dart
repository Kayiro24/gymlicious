import 'dart:convert';

import 'package:gym_tracker/core/clock/iso_date_time.dart';
import 'package:gym_tracker/core/storage/file_gateway.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_cache.dart';
import 'package:gym_tracker/features/quotes/domain/quote_refresher.dart';
import 'package:gym_tracker/features/quotes/domain/rate_budget.dart';

/// Reads and writes `quotes_cache.json`. A damaged cache is simply dropped.
class QuoteCacheStore implements QuoteCacheRepository {
  const new(this.files);

  static const fileName = 'quotes_cache.json';

  final FileGateway files;

  @override
  Future<QuoteCache> load() async {
    try {
      final text = await files.readString(fileName);
      return text == null ? const QuoteCache() : _decode(jsonDecode(text));
    } on Object {
      return const QuoteCache();
    }
  }

  @override
  Future<void> save(QuoteCache cache) =>
      files.writeString(fileName, jsonEncode(_encode(cache)));

  @override
  Future<void> clear() => files.delete(fileName);

  static Map<String, Object?> _encode(QuoteCache cache) => {
    'quotes': [
      for (final quote in cache.quotes)
        {
          'id': quote.id,
          'text': quote.text,
          'author': quote.author,
          'sourceTitle': quote.sourceTitle,
          'category': quote.category.name,
          'provider': quote.provider,
          'fetchedAt': _format(quote.fetchedAt),
        },
    ],
    'budgets': {
      for (final MapEntry(:key, :value) in cache.budgets.entries)
        key: {
          'recentRequests': [
            for (final at in value.recentRequests) IsoDateTime.format(at),
          ],
          'blockedUntil': _format(value.blockedUntil),
          'consecutiveErrors': value.consecutiveErrors,
        },
    },
    'lastBackgroundRefresh': _format(cache.lastBackgroundRefresh),
  };

  static QuoteCache _decode(Object? raw) {
    final json = JsonCast.object(raw, fileName);
    final budgets = JsonCast.optionalObject(json['budgets'], 'budgets') ?? {};
    return QuoteCache(
      quotes: [
        for (final item in JsonCast.objectList(json['quotes'], 'quotes'))
          Quote(
            id: item['id'] as String,
            text: item['text'] as String,
            author: item['author'] as String?,
            sourceTitle: item['sourceTitle'] as String?,
            category:
                QuoteCategory.tryParse(item['category'] as String?) ??
                QuoteCategory.gym,
            provider: item['provider'] as String,
            fetchedAt: IsoDateTime.tryParse(item['fetchedAt'] as String?),
          ),
      ],
      budgets: {
        for (final MapEntry(:key, :value) in budgets.entries)
          key: _decodeBudget(JsonCast.object(value, key)),
      },
      lastBackgroundRefresh: IsoDateTime.tryParse(
        json['lastBackgroundRefresh'] as String?,
      ),
    );
  }

  static RateBudget _decodeBudget(Map<String, dynamic> json) => RateBudget(
    recentRequests: [
      for (final at in (json['recentRequests'] as List<dynamic>?) ?? const [])
        ?IsoDateTime.tryParse(at as String?),
    ],
    blockedUntil: IsoDateTime.tryParse(json['blockedUntil'] as String?),
    consecutiveErrors: (json['consecutiveErrors'] as int?) ?? 0,
  );

  static String? _format(DateTime? value) =>
      value == null ? null : IsoDateTime.format(value);
}
