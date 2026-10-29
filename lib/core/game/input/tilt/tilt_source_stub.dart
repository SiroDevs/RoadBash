// Project imports:
import 'tilt_source_base.dart';

/// Creates a tilt source that never reports anything.
TiltSource createTiltSource() => _NoTilt();

/// Tilt source for platforms without sensors.
class _NoTilt implements TiltSource {
  @override
  Stream<TiltSample> get samples => const Stream<TiltSample>.empty();

  @override
  bool get needsPermission => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  void dispose() {}
}
