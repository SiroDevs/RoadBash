// Dart imports:
import 'dart:async';

// Package imports:
import 'package:sensors_plus/sensors_plus.dart';

// Project imports:
import 'tilt_source_base.dart';

/// Android and iOS. sensors_plus already reports iOS in the Android sign
/// convention, so no flipping is needed here.
TiltSource createTiltSource() => _NativeTilt();

class _NativeTilt implements TiltSource {
  _NativeTilt() {
    _sub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((e) => _out.add(TiltSample(e.x, e.y)), onError: (Object _) {});
  }

  final StreamController<TiltSample> _out = StreamController.broadcast();
  late final StreamSubscription<AccelerometerEvent> _sub;

  @override
  Stream<TiltSample> get samples => _out.stream;

  @override
  bool get needsPermission => false;

  @override
  Future<bool> requestPermission() async => true;

  @override
  void dispose() {
    _sub.cancel();
    _out.close();
  }
}
