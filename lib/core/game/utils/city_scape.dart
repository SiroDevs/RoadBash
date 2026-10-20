import 'dart:ui';

class CityScape {
  CityScape() : _shapes = [for (final s in _data) _build(s)];

  static const double _left = 37;
  static const double _baseline = 90;
  static const double _top = 11;
  static const double _tile = 150;

  static const List<List<double>> _data = [
    [
      104, 90, 104, 43, 106, 43, 106, 42, 105, 42, 105, 41, 102, 39, 105, 38,
      104, 37, 115, 37, 114, 38, 117, 39, 114, 41, 114, 42, 113, 42, 113, 43,
      115, 43, 115, 90,
    ],
    [
      114, 90, 114, 88, 106, 84, 118, 73, 129, 84, 121, 88, 121, 90,
    ],
    [
      162, 90, 162, 44, 161, 44, 161, 41, 162, 41, 162, 36, 158, 36, 158, 34,
      156, 34, 156, 33, 151, 33, 151, 34, 148, 34, 148, 37, 144, 37, 144, 41,
      145, 41, 145, 43, 144, 43, 144, 90,
    ],
    [
      162, 90, 164, 79, 163, 52.5, 167.5, 50.5, 167.5, 52.5, 169.5, 52.5,
      169.5, 50.5, 174, 53, 173, 79, 175, 90,
    ],
    [
      128, 91, 128, 53, 129, 53, 129, 51, 130, 51, 130, 46, 131, 46, 131, 49,
      136, 49, 136, 46, 137, 46, 137, 51, 138, 51, 138, 53, 139, 53, 139, 91,
    ],
    [
      100, 90, 100, 81, 98, 81, 98, 51, 94.5, 51, 94.5, 47, 93, 47, 93, 29,
      92, 29, 92, 25, 91, 25, 91, 20.5, 88, 14.5, 88, 11, 88, 14.5, 84, 20.5,
      84, 25, 83, 25, 83, 29, 82, 29, 82, 47, 81, 47, 81, 51, 77.5, 51,
      77.5, 81, 75, 81, 75, 90,
    ],
    [
      72, 90, 72, 65, 70, 65, 70, 58, 69, 58, 69, 56, 69, 58, 68, 58, 68, 65,
      67, 65, 67, 90,
    ],
    [
      52, 90, 58, 49, 58, 48, 59, 47, 58, 45, 61, 45, 61, 43, 61, 42, 60, 38,
      61, 36, 60, 34, 62, 32, 62, 28, 61, 28, 62, 27, 62, 25, 62, 27, 64, 27,
      62, 28, 62, 32, 63, 33, 64, 35, 63, 36, 64, 37, 64, 39, 63, 42, 63, 43,
      63, 45, 67, 45, 74, 90,
    ],
    [
      39, 90, 38, 87, 39, 84, 38, 79, 39, 76, 38, 74, 39, 71, 37, 67, 39, 63,
      37, 60, 39, 57, 37, 53, 49, 50, 48, 53, 49, 56, 48, 59, 49, 63, 48, 67,
      49, 70, 48, 73, 49, 76, 48, 79, 49, 83, 48, 88, 49, 90,
    ],
  ];

  static Path _build(List<double> pts) {
    final path = Path()..moveTo(pts[0], pts[1]);
    for (var i = 2; i < pts.length; i += 2) {
      path.lineTo(pts[i], pts[i + 1]);
    }
    return path..close();
  }

  final List<Path> _shapes;
  final Paint _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.round;

  void paint(
    Canvas canvas, {
    required double width,
    required double baseY,
    required double height,
    required double scroll,
    required Paint fill,
    Color? outline,
    double outlineWidth = 1,
  }) {
    final s = height / (_baseline - _top);
    final tile = _tile * s;
    final first = (scroll / tile).floor();
    if (outline != null) {
      _stroke
        ..color = outline
        ..strokeWidth = outlineWidth / s;
    }
    for (var i = first; i * tile - scroll < width; i++) {
      canvas
        ..save()
        ..translate(i * tile - scroll, baseY)
        ..scale(s, s)
        ..translate(-_left, -_baseline);
      for (final shape in _shapes) {
        canvas.drawPath(shape, fill);
        if (outline != null) canvas.drawPath(shape, _stroke);
      }
      canvas.restore();
    }
  }
}