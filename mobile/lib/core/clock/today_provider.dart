import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/clock/calendar_date.dart';
import 'package:gym_tracker/core/providers.dart';

/// Today's local date, refreshed at local midnight and whenever the app
/// resumes, so date-based screens roll over (including Jan 1) while open.
class TodayController extends Notifier<CalendarDate> {
  Timer? _midnight;
  AppLifecycleListener? _lifecycle;

  @override
  CalendarDate build() {
    _lifecycle ??= AppLifecycleListener(onResume: _refresh);
    ref.onDispose(() {
      _midnight?.cancel();
      _lifecycle?.dispose();
      _lifecycle = null;
    });
    final now = ref.watch(clockProvider).now();
    _scheduleMidnight(now);
    return CalendarDate.fromDateTime(now);
  }

  void _refresh() {
    final now = ref.read(clockProvider).now();
    final today = CalendarDate.fromDateTime(now);
    if (today != state) {
      state = today;
    }
    _scheduleMidnight(now);
  }

  /// Local midnight from calendar fields, not "now + 24h", so DST days
  /// of 23 or 25 hours still roll over at the right moment.
  void _scheduleMidnight(DateTime now) {
    _midnight?.cancel();
    final next = CalendarDate.fromDateTime(now).addDays(1).toLocalDateTime();
    _midnight = Timer(next.difference(now), _refresh);
  }
}

final todayProvider = NotifierProvider<TodayController, CalendarDate>(
  TodayController.new,
);
