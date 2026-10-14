import 'dart:ui';

/// The flame outline used by `FlameIcon` and the app icon generator, in a
/// unit square: a start point, then cubic segments (control 1, control 2,
/// end).
abstract final class FlameShape {
  static const outer = [
    0.5, 1.0, //
    0.12, 1.0, 0.08, 0.62, 0.28, 0.42,
    0.36, 0.3, 0.4, 0.16, 0.54, 0.0,
    0.6, 0.2, 0.94, 0.4, 0.88, 0.66,
    0.86, 0.9, 0.7, 1.0, 0.5, 1.0,
  ];

  static const core = [
    0.5, 0.96, //
    0.3, 0.96, 0.28, 0.76, 0.4, 0.62,
    0.46, 0.54, 0.48, 0.46, 0.55, 0.38,
    0.62, 0.52, 0.74, 0.62, 0.71, 0.78,
    0.69, 0.92, 0.6, 0.96, 0.5, 0.96,
  ];

  /// [points] scaled into [bounds].
  static Path path(Rect bounds, List<double> points) {
    Offset at(int i) => Offset(
      bounds.left + points[i] * bounds.width,
      bounds.top + points[i + 1] * bounds.height,
    );
    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 2; i < points.length; i += 6) {
      final (a, b, c) = (at(i), at(i + 2), at(i + 4));
      path.cubicTo(a.dx, a.dy, b.dx, b.dy, c.dx, c.dy);
    }
    return path..close();
  }
}
