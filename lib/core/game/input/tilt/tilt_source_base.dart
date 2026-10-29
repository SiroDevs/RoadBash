/// One accelerometer reading in the screen plane.
class TiltSample {
  const TiltSample(this.x, this.y);

  final double x;
  final double y;
}

/// Source of tilt samples for the current platform.
abstract class TiltSource {
  Stream<TiltSample> get samples;

  bool get needsPermission;

  Future<bool> requestPermission();

  void dispose();
}
