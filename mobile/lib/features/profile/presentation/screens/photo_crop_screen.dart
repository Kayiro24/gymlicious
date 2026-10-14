import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/l10n/generated/app_localizations.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/core/theme/generated/design_tokens.g.dart';
import 'package:gym_tracker/design_system/app_button.dart';
import 'package:gym_tracker/design_system/app_loading_ring.dart';
import 'package:gym_tracker/features/profile/domain/photo_crop.dart';

/// Instagram-style framing: drag and pinch the photo under a fixed circle.
/// Pops with the framed square, or null when cancelled.
class PhotoCropScreen extends StatefulWidget {
  const new({required this.bytes, super.key});

  final Uint8List bytes;

  static Future<PhotoCrop?> open(BuildContext context, Uint8List bytes) =>
      Navigator.of(context).push<PhotoCrop>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => PhotoCropScreen(bytes: bytes),
        ),
      );

  @override
  State<PhotoCropScreen> createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  static const double _maxZoom = 4;
  static const double _circleMargin = TokenSpace.xl;

  ui.Image? _image;
  double _zoom = 1;
  Offset _offset = Offset.zero;
  double _diameter = 0;
  double _zoomAtGestureStart = 1;

  @override
  void initState() {
    super.initState();
    unawaited(_decode());
  }

  Future<void> _decode() async {
    // The engine applies EXIF orientation, matching what the store crops.
    final codec = await ui.instantiateImageCodec(widget.bytes);
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(() => _image = frame.image);
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  /// Scale at which the image's shorter side exactly fills the circle.
  double get _baseScale {
    final image = _image!;
    return _diameter / math.min(image.width, image.height);
  }

  Size get _shownSize {
    final image = _image!;
    final scale = _baseScale * _zoom;
    return Size(image.width * scale, image.height * scale);
  }

  /// Keeps the circle covered: the image's edges can't move inside it.
  Offset _clamp(Offset offset) {
    final size = _shownSize;
    return Offset(
      offset.dx.clamp(_diameter - size.width, 0),
      offset.dy.clamp(_diameter - size.height, 0),
    );
  }

  void _centre() {
    final size = _shownSize;
    _offset = Offset(
      (_diameter - size.width) / 2,
      (_diameter - size.height) / 2,
    );
  }

  /// Zooms around [focal] (in circle coordinates) so that point stays put.
  void _zoomTo(double zoom, Offset focal) {
    final next = zoom.clamp(1.0, _maxZoom);
    final ratio = next / _zoom;
    _offset = focal - (focal - _offset) * ratio;
    _zoom = next;
    _offset = _clamp(_offset);
  }

  void _done() {
    final image = _image!;
    final scale = _baseScale * _zoom;
    final side = _diameter / scale;
    Navigator.of(context).pop<PhotoCrop>((
      left: -_offset.dx / scale / image.width,
      top: -_offset.dy / scale / image.height,
      width: side / image.width,
      height: side / image.height,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final image = _image;
    return Theme(
      data: AppTheme.dark(),
      child: Scaffold(
        backgroundColor: AppColors.dark.background,
        appBar: AppBar(
          backgroundColor: AppColors.dark.background,
          title: Text(l10n.cropTitle),
          leading: IconButton(
            tooltip: l10n.commonCancel,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: image == null
              ? Center(child: AppLoadingRing(semanticLabel: l10n.commonLoading))
              : Column(
                  children: [
                    Expanded(child: _frame(image)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TokenSpace.xl,
                      ),
                      child: Text(
                        l10n.cropHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.dark.textSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TokenSpace.lg,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.zoom_out,
                            color: AppColors.dark.textSecondary,
                          ),
                          Expanded(
                            child: Slider(
                              value: _zoom,
                              min: 1,
                              max: _maxZoom,
                              label: l10n.cropZoom,
                              semanticFormatterCallback: (value) =>
                                  '${l10n.cropZoom} '
                                  '${value.toStringAsFixed(1)}×',
                              onChanged: (value) => setState(
                                () => _zoomTo(
                                  value,
                                  Offset(_diameter / 2, _diameter / 2),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.zoom_in,
                            color: AppColors.dark.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        TokenSpace.lg,
                        0,
                        TokenSpace.lg,
                        TokenSpace.lg,
                      ),
                      child: AppButton(
                        label: l10n.cropUse,
                        icon: Icons.check,
                        isExpanded: true,
                        onPressed: _done,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _frame(ui.Image image) => LayoutBuilder(
    builder: (context, constraints) {
      final diameter =
          math.min(constraints.maxWidth, constraints.maxHeight) -
          _circleMargin * 2;
      if (diameter != _diameter) {
        _diameter = diameter;
        _offset = Offset.zero;
        _centre();
      }
      final size = _shownSize;
      final origin = Offset(
        (constraints.maxWidth - diameter) / 2,
        (constraints.maxHeight - diameter) / 2,
      );
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (_) => _zoomAtGestureStart = _zoom,
        onScaleUpdate: (details) => setState(() {
          _offset = _clamp(_offset + details.focalPointDelta);
          _zoomTo(
            _zoomAtGestureStart * details.scale,
            details.localFocalPoint - origin,
          );
        }),
        onDoubleTap: () => setState(() {
          _zoom = 1;
          _centre();
        }),
        child: Stack(
          children: [
            Positioned(
              left: origin.dx + _offset.dx,
              top: origin.dy + _offset.dy,
              width: size.width,
              height: size.height,
              child: RawImage(image: image, fit: BoxFit.fill),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CircleMask(origin: origin, diameter: diameter),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Darkens everything outside the circle and outlines it.
class _CircleMask extends CustomPainter {
  new({required this.origin, required this.diameter});

  final Offset origin;
  final double diameter;

  static const _scrimOpacity = 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Rect.fromLTWH(origin.dx, origin.dy, diameter, diameter);
    final scrim = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(circle);
    canvas
      ..drawPath(
        scrim,
        Paint()
          ..color = AppColors.dark.background.withValues(alpha: _scrimOpacity),
      )
      ..drawOval(
        circle,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.dark.textPrimary,
      );
  }

  @override
  bool shouldRepaint(_CircleMask oldDelegate) =>
      oldDelegate.origin != origin || oldDelegate.diameter != diameter;
}
