import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/quotes/domain/quote.dart';
import 'package:gym_tracker/features/quotes/presentation/state/quote_controller.dart';
import 'package:gym_tracker/shared/quote_card.dart';

/// The quote on Home; renders nothing when quotes are off.
class HomeQuoteCard extends ConsumerWidget {
  const new({super.key});

  /// "Author" or "Character, Anime Title"; bundled quotes have none.
  static String? attributionOf(Quote quote) {
    final parts = [?quote.author, ?quote.sourceTitle];
    return parts.isEmpty ? null : parts.join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteControllerProvider);
    final quote = state.quote;
    if (state.isHidden || quote == null) {
      return const SizedBox.shrink();
    }
    return QuoteCard(
      text: quote.text,
      attribution: attributionOf(quote),
      isLoading: state.isFetching,
      onRefresh: () => ref.read(quoteControllerProvider.notifier).showNext(),
    );
  }
}
