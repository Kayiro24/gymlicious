import 'dart:async';

/// Runs async tasks one at a time, in submission order.
class WriteQueue {
  Future<void> _tail = Future<void>.value();

  Future<void> enqueue(Future<void> Function() task) {
    final completer = Completer<void>();
    _tail = _tail.then((_) async {
      try {
        await task();
        completer.complete();
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
