class TiltSample {
  const TiltSample(this.x, this.y);

  final double x;
  final double y;
}

abstract class TiltSource {
  Stream<TiltSample> get samples;

  bool get needsPermission;

  Future<bool> requestPermission();

  void dispose();
}
