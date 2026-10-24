/// One accelerometer reading, in m/s², already in the Android convention:
/// gravity "up" measured along the device's own axes while the screen faces you.
/// [x] points to the right of the device, [y] to the top of it.
class TiltSample {
  const TiltSample(this.x, this.y);

  final double x;
  final double y;
}

/// Where tilt readings come from. There is one implementation per platform:
/// sensors_plus on Android and iOS, the browser's devicemotion event on the web.
abstract class TiltSource {
  Stream<TiltSample> get samples;

  /// True when the platform wants the player to allow motion access first
  /// (iOS Safari). [requestPermission] must then be called from a tap.
  bool get needsPermission;

  Future<bool> requestPermission();

  void dispose();
}
