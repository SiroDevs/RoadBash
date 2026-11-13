// Dart imports:
import 'dart:ui';

/// Scrolls tread paths downward while keeping the tire body fixed.
class WheelThreadMotion implements Canvas {
  WheelThreadMotion(
    this.target, {
    required this.phase,
    required this.clipBounds,
  });

  final Canvas target;
  final double phase;
  final Rect clipBounds;

  @override
  void save() => target.save();

  @override
  void restore() => target.restore();

  @override
  void translate(double dx, double dy) => target.translate(dx, dy);

  @override
  void rotate(double radians) => target.rotate(radians);

  @override
  void drawOval(Rect rect, Paint paint) => target.drawOval(rect, paint);

  @override
  void drawRRect(RRect rrect, Paint paint) => target.drawRRect(rrect, paint);

  @override
  void drawPath(Path path, Paint paint) {
    final offsetY = -phase * clipBounds.height;
    _drawClipped(path, paint, offsetY);
    _drawClipped(path, paint, offsetY + clipBounds.height);
  }

  void _drawClipped(Path path, Paint paint, double offsetY) {
    target
      ..save()
      ..clipRect(clipBounds)
      ..translate(0, offsetY)
      ..drawPath(path, paint)
      ..restore();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unsupported wheel canvas call: ${invocation.memberName}',
  );
}
