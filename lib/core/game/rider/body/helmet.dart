// Project imports:
part of '../rider_painter.dart';

class Helmet extends RiderPartPainter {
  Helmet(super.look);

  late final Color _shade = look.helmetShade;

  static const double _mid = RiderPartPainter.midX;

  void paint(Canvas canva, RiderPose pose) {
    final neckY = 15 + tuckOf(pose);
    final foot = pose.foot.clamp(0.0, 1.0);
    double m(double moving, double stopped) => moving + (stopped - moving) * foot;

    fill(
      canva,
      Rect.fromLTRB(
        53,
        m(neckY - 30, neckY - 40),
        67,
        m(neckY - 20, neckY - 30),
      ),
      look.neck,
      5,
    );

    canva.save();
    canva.translate(_mid, neckY);
    canva.rotate(-pose.lean * 0.3);
    canva.translate(-_mid, -neckY);

    final cy = neckY - 45;
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(_mid, m(cy, cy - 10)),
        width: 30,
        height: 32,
      ),
      look.helmet,
    );
    quad(canva, _shade, [
      Offset(_mid - 13, m(cy + 8, cy)),
      Offset(_mid + 13, m(cy + 8, cy)),
      Offset(_mid + 8, m(cy + 15, cy + 7)),
      Offset(_mid - 8, m(cy + 15, cy + 7)),
    ]);
    fill(
      canva,
      Rect.fromLTRB(
        _mid - 5,
        m(cy - 13, cy - 20),
        _mid + 10,
        m(cy - 5, cy - 12),
      ),
      _shade,
      5,
    );
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(_mid - 5, m(cy - 5, cy - 12)),
        width: 15,
        height: 11,
      ),
      RiderLook.helmetGloss,
    );
    canva.restore();
  }
}
