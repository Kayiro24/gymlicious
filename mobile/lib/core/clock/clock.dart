/// Source of the current time, injected so date logic is testable.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const new();

  @override
  DateTime now() => DateTime.now();
}
