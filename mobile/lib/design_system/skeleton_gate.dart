import 'dart:async';

import 'package:flutter/widgets.dart';

/// Anti-flicker: shows [skeleton] only if loading lasts longer than
/// [showAfter], and once shown keeps it for at least [minimumVisible].
class SkeletonGate extends StatefulWidget {
  const new({
    required this.isLoading,
    required this.skeleton,
    required this.child,
    super.key,
    this.showAfter = const Duration(milliseconds: 150),
    this.minimumVisible = const Duration(milliseconds: 300),
  });

  final bool isLoading;
  final Widget skeleton;
  final Widget child;
  final Duration showAfter;
  final Duration minimumVisible;

  @override
  State<SkeletonGate> createState() => _SkeletonGateState();
}

enum _GatePhase { waiting, skeleton, content }

class _SkeletonGateState extends State<SkeletonGate> {
  _GatePhase _phase = _GatePhase.content;
  Timer? _timer;
  late DateTime _skeletonShownAt;

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) {
      _startWaiting();
    }
  }

  @override
  void didUpdateWidget(SkeletonGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading == oldWidget.isLoading) {
      return;
    }
    if (widget.isLoading) {
      _startWaiting();
    } else {
      _finishLoading();
    }
  }

  void _startWaiting() {
    _timer?.cancel();
    _phase = _GatePhase.waiting;
    _timer = Timer(widget.showAfter, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = _GatePhase.skeleton;
        _skeletonShownAt = DateTime.now();
      });
    });
  }

  void _finishLoading() {
    _timer?.cancel();
    if (_phase != _GatePhase.skeleton) {
      setState(() => _phase = _GatePhase.content);
      return;
    }
    final shownFor = DateTime.now().difference(_skeletonShownAt);
    final remaining = widget.minimumVisible - shownFor;
    if (remaining <= Duration.zero) {
      setState(() => _phase = _GatePhase.content);
      return;
    }
    _timer = Timer(remaining, () {
      if (mounted) {
        setState(() => _phase = _GatePhase.content);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => switch (_phase) {
    _GatePhase.waiting => const SizedBox.shrink(),
    _GatePhase.skeleton => widget.skeleton,
    _GatePhase.content => widget.child,
  };
}
