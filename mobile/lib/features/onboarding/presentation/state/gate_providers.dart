import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers.dart';
import 'package:gym_tracker/features/onboarding/data/gate_draft_store.dart';
import 'package:gym_tracker/features/profile/profile.dart';

final gateDraftStoreProvider = Provider<GateDraftStore>(
  (ref) => GateDraftStore(ref.watch(fileGatewayProvider)),
);

final initialGateDraftProvider = FutureProvider<ProfileDraft>(
  (ref) => ref.watch(gateDraftStoreProvider).load(),
);

/// Saves the draft at most a few times a second while the user types.
class GateDraftSaver {
  new(this._store);

  static const _delay = Duration(milliseconds: 400);

  final GateDraftStore _store;
  Timer? _timer;
  ProfileDraft? _pending;

  void schedule(ProfileDraft draft) {
    _pending = draft;
    _timer?.cancel();
    _timer = Timer(_delay, flush);
  }

  void flush() {
    _timer?.cancel();
    final draft = _pending;
    _pending = null;
    if (draft != null) {
      unawaited(_store.save(draft));
    }
  }

  void cancel() {
    _timer?.cancel();
    _pending = null;
  }
}
