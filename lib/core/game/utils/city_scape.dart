import 'dart:ui';

typedef _Piece = (Path, Color, double);

class CityScape {
  static const double _left = 12;
  static const double _baseline = 90;
  static const double _top = 11;
  static const double _tile = 190;
    static const Color colorB97A57 = Color(0xFFB97A57);
  static const Color color3F48CC = Color(0xFF3F48CC);
  static const Color color00A2E8 = Color(0xFF00A2E8);
  static const Color color99D9EA = Color(0xFF99D9EA);
  static const Color colorC8BFE7 = Color(0xFFC8BFE7);
  static const Color color7092BE = Color(0xFF7092BE);
  static const Color color7F7F7F = Color(0xFF7F7F7F);
  static const Color colorC3C3C3 = Color(0xFFC3C3C3);
  static const Color color000000 = Color(0xFF000000);
  static const Color colorFF7F27 = Color(0xFFFF7F27);
  static const Color color880015 = Color(0xFF880015);

  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final List<_Piece> _pieces = _build();

  static List<_Piece> _build() {
    final out = <_Piece>[];

    void poly(List<double> p, Color color, {Color? edge}) {
      final path = Path()..moveTo(p[0], p[1]);
      for (var i = 2; i < p.length; i += 2) {
        path.lineTo(p[i], p[i + 1]);
      }
      path.close();
      out.add((path, color, 0));
      if (edge != null) out.add((path, edge, 0.25));
    }

    void rect(double l, double t, double r, double b, Color color) =>
        out.add((Path()..addRect(Rect.fromLTRB(l, t, r, b)), color, 0));

    void oval(double l, double t, double r, double b, Color color) =>
        out.add((Path()..addOval(Rect.fromLTRB(l, t, r, b)), color, 0));

    void lines(List<double> s, Color color, [double width = 0.25]) {
      final path = Path();
      for (var i = 0; i < s.length; i += 4) {
        path
          ..moveTo(s[i], s[i + 1])
          ..lineTo(s[i + 2], s[i + 3]);
      }
      out.add((path, color, width));
    }

    poly([
      162, 90, 162, 43, 161, 43, 161, 41, 162, 41, 162, 36, 158, 36, 158, 34,
      156, 34, 156, 33, 151, 33, 151, 34, 149, 34, 149, 36, 144, 36, 144, 41,
      145, 41, 145, 43, 144, 43, 144, 90,
    ], colorB97A57);
    poly([
      162, 90, 164, 79, 163, 52.5, 167.5, 50.5, 167.5, 52.5, 169.5, 52.5,
      169.5, 50.5, 174, 53, 173, 79, 175, 90,
    ], color3F48CC);
    poly([
      116, 90, 116, 61, 117, 61, 117, 60, 119, 60, 119, 61, 122, 61, 122, 90,
    ], color00A2E8);
    poly([
      120, 43, 120, 33, 121, 33, 121, 43, 123, 43, 123, 20, 122, 18, 121, 20,
      121, 43,
    ], color99D9EA, edge: color99D9EA);
    poly([43, 46, 43, 90, 30, 90, 30, 45, 34, 45, 34, 46], color00A2E8);
    poly([144, 90, 144, 60, 143, 60, 143, 59, 139, 59, 139, 90], color3F48CC);
    poly([
      134, 46, 134, 90, 120, 90, 119, 43, 128, 43, 128, 44, 129, 44, 129, 42,
      132, 42, 132, 46,
    ], color99D9EA);
    poly([12, 90, 12, 65, 13, 64, 13, 63, 22, 63, 22, 90], colorC8BFE7);
    poly([
      34, 90, 34, 60, 32, 60, 32, 56, 23, 56, 23, 77, 20, 77, 20, 78, 19, 78,
      19, 90,
    ], color7092BE);
    poly([37, 90, 37, 72, 30, 72, 30, 90], color3F48CC);
    poly([
      39, 90, 38, 87, 39, 83, 38, 79, 39, 76, 38, 74, 39, 71, 37, 67, 39, 63,
      37, 60, 39, 57, 37, 53, 49, 50, 48, 53, 49, 56, 48, 59, 49, 63, 48, 67,
      49, 70, 48, 73, 49, 76, 48, 79, 49, 83, 48, 88, 49, 90,
    ], color3F48CC, edge: color7F7F7F);
    poly([
      50, 90, 50, 68, 51, 68, 51, 67, 52, 67, 52, 65, 53, 65, 53, 64, 54, 62,
      56, 61, 64, 61, 65, 90,
    ], color3F48CC);
    poly([
      76, 90, 76, 41, 72, 41, 72, 40, 68, 40, 68, 41, 65, 41, 64, 90,
    ], color00A2E8);
    poly([76, 90, 77, 53, 84, 53, 85, 90], color3F48CC);
    poly([
      52, 90, 58, 49, 57, 47, 59, 47, 58, 45, 61, 45, 61, 43, 61, 42, 60, 38,
      61, 36, 60, 35, 60, 33, 62, 32, 62, 25, 62, 28, 61, 28, 62, 28, 63, 28,
      62, 28, 62, 32, 64, 33, 64, 35, 63, 36, 64, 38, 64, 40, 63, 42, 63, 43,
      63, 45, 67, 45, 74, 90,
    ], colorC3C3C3, edge: color7F7F7F);
    poly([
      96, 90, 96, 36, 98, 36, 98, 33, 108, 33, 108, 36, 109, 36, 109, 90,
    ], color00A2E8);
    poly([122, 90, 122, 64, 128, 63, 128, 90], color00A2E8);
    poly([
      20, 90, 20, 83, 35, 83, 35, 90, 30, 90, 30, 88, 25, 88, 25, 90,
    ], colorB97A57);
    poly([
      190, 90, 190, 58, 188, 58, 188, 57, 177, 57, 177, 58, 175, 58, 175, 90,
    ], color7092BE);
    oval(178, 53, 187, 60, color7092BE);
    oval(124, 40, 127, 44, color99D9EA);
    poly([
      150, 41, 150, 39, 156, 39, 156, 41, 161, 41, 161, 43, 156, 43, 156, 90,
      150, 90, 150, 43, 145, 43, 145, 41,
    ], color000000);
    poly([
      72, 90, 72, 65, 70, 65, 70, 58, 69, 58, 69, 56, 69, 58, 68, 58, 68, 65,
      67, 65, 67, 90,
    ], colorFF7F27);
    rect(158, 45, 160, 90, color000000);
    rect(146, 45, 148, 90, color000000);
    poly([
      156, 90, 156, 83, 154, 83, 154, 79, 135, 79, 135, 81, 134, 81, 133, 83,
      133, 90,
    ], colorFF7F27);
    poly([125, 90, 125, 69, 130, 69, 130, 90], color3F48CC);
    poly([
      128, 90, 128, 53, 129, 53, 129, 51, 130, 51, 130, 49, 137, 49, 137, 51,
      138, 51, 138, 53, 139, 53, 139, 90,
    ], color000000);
    poly([
      104, 90, 104, 43, 106, 43, 106, 42, 105, 42, 105, 41, 102, 39, 105, 38,
      104, 37, 115, 37, 114, 38, 117, 39, 114, 41, 114, 42, 113, 42, 113, 43,
      115, 43, 115, 90,
    ], colorB97A57, edge: colorB97A57);
    poly([
      78, 68, 78, 51, 81, 51, 81, 47, 82, 47, 82, 29, 83, 29, 83, 25, 84, 25,
      84, 21, 88, 14, 88, 11, 88, 14, 91, 21, 91, 25, 92, 25, 92, 29, 93, 29,
      93, 47, 95, 47, 95, 51, 98, 51, 98, 68,
    ], colorB97A57);
    poly([
      100, 90, 100, 81, 98, 81, 98, 68, 78, 68, 78, 81, 75, 81, 75, 90,
    ], color880015);
    rect(86, 51, 90, 80, color000000);
    lines([
      58, 49, 63, 90, 67, 45, 63, 90, 48, 52, 37, 53, 48, 53, 39, 57, 39, 57,
      48, 59, 49, 56, 39, 57, 37, 60, 48, 59, 48, 59, 39, 63, 39, 63, 49, 63,
      48, 67, 39, 63, 48, 67, 37, 67, 39, 71, 48, 67, 39, 71, 49, 70, 39, 71,
      48, 73, 48, 73, 39, 76, 48, 73, 38, 74, 39, 76, 49, 76, 48, 79, 39, 76,
      48, 79, 38, 79, 48, 79, 39, 83, 39, 83, 49, 83, 49, 83, 38, 87, 38, 87,
      48, 88,
    ], color7F7F7F);

    final glass = Path();
    for (var y = 20.0; y <= 42; y += 2) {
      glass
        ..moveTo(y < 34 ? 121 : 120, y)
        ..lineTo(123, y);
    }
    out.add((glass, color99D9EA, 0.25));

    lines([130.5, 46, 130.5, 89.5, 136.5, 46, 136.5, 89.5], color00A2E8, 1);

    final bars = Path()..addRect(const Rect.fromLTRB(105, 41, 114, 42));
    for (var y = 43.0; y <= 88; y += 1.5) {
      bars.addRect(Rect.fromLTRB(103.5, y, 115.5, y + 1));
    }
    out.add((bars, color7F7F7F, 0));

    poly([
      114, 90, 114, 88, 106, 84, 118, 73, 129, 84, 121, 88, 121, 90,
    ], colorFF7F27);
    lines([102, 39, 117, 39], colorB97A57);
    lines([102, 39, 117, 39, 105, 38, 114.5, 38], color7F7F7F);
    return out;
  }

  void paint(
    Canvas canvas, {
    required double width,
    required double baseY,
    required double height,
    required double scroll,
    Color? haze,
  }) {
    final s = height / (_baseline - _top);
    final tile = _tile * s;
    _paint.colorFilter = haze == null
        ? null
        : ColorFilter.mode(haze, BlendMode.srcOver);
    for (var i = (scroll / tile).floor(); i * tile - scroll < width; i++) {
      canvas
        ..save()
        ..translate(i * tile - scroll, baseY)
        ..scale(s)
        ..translate(-_left, -_baseline);
      for (final (path, color, w) in _pieces) {
        _paint
          ..color = color
          ..style = w == 0 ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = w;
        canvas.drawPath(path, _paint);
      }
      canvas.restore();
    }
  }
}