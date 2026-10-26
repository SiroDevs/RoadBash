// Project imports:
import 'tilt_source_base.dart';

TiltSource createTiltSource() => _NoTilt();

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
