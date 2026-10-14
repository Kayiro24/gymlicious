import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gym_tracker/core/storage/json_cast.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/domain/quote_validator.dart';

class BundledQuotesLoader {
  const new(this.bundle);

  static const asset = 'assets/quotes/bundled_quotes.json';
  static const provider = 'bundled';

  final AssetBundle bundle;

  Future<List<Quote>> load() async {
    final json = jsonDecode(await bundle.loadString(asset));
    return [
      for (final item in JsonCast.objectList(json, asset))
        Quote(
          id: QuoteValidator.idFor(item['text'] as String),
          text: item['text'] as String,
          author: item['author'] as String?,
          category:
              QuoteCategory.tryParse(item['category'] as String?) ??
              QuoteCategory.gym,
          provider: provider,
        ),
    ];
  }
}
