/// Where the dot grid and the text line sit on a wallpaper of a given pixel
/// size. Mirrored exactly by the Kotlin renderer (WallpaperFrame.kt).
class WallpaperFrame {
  const new({
    required this.gridLeft,
    required this.gridTop,
    required this.gridWidth,
    required this.gridHeight,
    required this.textSize,
    required this.textCenterY,
  });

  factory compute({
    required double width,
    required double height,
    required int topMarginPercent,
    required double padding,
    required bool hasText,
  }) {
    final textSize = width * textSizeRatio;
    final textBlock = hasText ? textSize * textBlockRatio : 0.0;
    final gridTop = height * topMarginPercent / _percent;
    final gridBottom = height - padding - textBlock;
    return WallpaperFrame(
      gridLeft: padding,
      gridTop: gridTop,
      gridWidth: (width - padding * 2).clamp(0, width),
      gridHeight: (gridBottom - gridTop).clamp(0, height),
      textSize: textSize,
      textCenterY: height - padding - textBlock / 2,
    );
  }

  static const textSizeRatio = 0.035;

  /// Text block height as a multiple of the text size (line plus spacing).
  static const textBlockRatio = 3.0;
  static const _percent = 100;

  final double gridLeft;
  final double gridTop;
  final double gridWidth;
  final double gridHeight;
  final double textSize;
  final double textCenterY;
}
