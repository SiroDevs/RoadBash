// Dart imports:
import 'dart:async';
import 'dart:js_interop';

// Project imports:
import 'tilt_source_base.dart';

// Flutter imports:
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;


TiltSource createTiltSource() => _WebTilt();

@JS('window')
external _Window get _window;

extension type _Window._(JSObject _) implements JSObject {
  external void addEventListener(String type, JSFunction listener);
  external void removeEventListener(String type, JSFunction listener);
}

extension type _Acceleration._(JSObject _) implements JSObject {
  external JSNumber? get x;
  external JSNumber? get y;
}

extension type _MotionEvent._(JSObject _) implements JSObject {
  external _Acceleration? get accelerationIncludingGravity;
}

@JS('DeviceMotionEvent')
extension type _DeviceMotion._(JSObject _) implements JSObject {
  @JS('requestPermission')
  external static JSAny? get permissionApi;

  external static JSPromise<JSString> requestPermission();
}

class _WebTilt implements TiltSource {
  _WebTilt() : needsPermission = _permissionRequired() {
    if (!needsPermission) _attach();
  }

  static bool _permissionRequired() {
    try {
      return _DeviceMotion.permissionApi != null;
    } catch (_) {
      return false;
    }
  }

  final StreamController<TiltSample> _out = StreamController.broadcast();

  final double _sign = defaultTargetPlatform == TargetPlatform.iOS ? -1 : 1;

  late final JSFunction _listener = _onMotion.toJS;
  bool _attached = false;

  @override
  final bool needsPermission;

  @override
  Stream<TiltSample> get samples => _out.stream;

  void _attach() {
    if (_attached) return;
    _attached = true;
    _window.addEventListener('devicemotion', _listener);
  }

  void _onMotion(_MotionEvent event) {
    final gravity = event.accelerationIncludingGravity;
    final gravityX = gravity?.x?.toDartDouble;
    final gravityY = gravity?.y?.toDartDouble;
    if (gravityX == null || gravityY == null || _out.isClosed) return;
    _out.add(TiltSample(gravityX * _sign, gravityY * _sign));
  }

  @override
  Future<bool> requestPermission() async {
    if (!needsPermission) {
      _attach();
      return true;
    }
    try {
      final answer = await _DeviceMotion.requestPermission().toDart;
      if (answer.toDart != 'granted') return false;
    } catch (_) {
      return false;
    }
    _attach();
    return true;
  }

  @override
  void dispose() {
    if (_attached) _window.removeEventListener('devicemotion', _listener);
    _attached = false;
    _out.close();
  }
}
