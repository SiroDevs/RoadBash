// Dart imports:
import 'dart:async';

// Package imports:
import 'package:gamepads/gamepads.dart' as gamepads;

// Project imports:
import 'gamepad_controls.dart';

/// Converts normalized controller events into RoadBash controls.
class GamepadInput {
  GamepadInput({required this.onChanged, required this.onPause});

  final void Function(GamepadControls controls) onChanged;
  final void Function() onPause;
  final Map<String, gamepads.NormalizedGamepadState> _states = {};
  final Map<String, bool> _pausePressed = {};
  StreamSubscription<gamepads.NormalizedGamepadEvent>? _events;
  StreamSubscription<gamepads.GamepadConnectionEvent>? _connections;
  String? _activeId;
  bool _disposed = false;

  /// Starts listening for controller input and connection changes.
  void start() {
    _events ??= gamepads.Gamepads.normalizedEvents.listen(_onEvent);
    _connections ??= gamepads.Gamepads.connectionEvents.listen(_onConnection);
  }

  /// Stops listening and releases all controller input.
  void dispose() {
    _disposed = true;
    unawaited(_events?.cancel());
    unawaited(_connections?.cancel());
    onChanged(GamepadControls.neutral);
  }

  /// Updates one controller's state and handles a new pause press.
  void _onEvent(gamepads.NormalizedGamepadEvent event) {
    if (_disposed) return;
    final state = _states.putIfAbsent(
      event.gamepadId,
      gamepads.NormalizedGamepadState.new,
    )..update(event);
    _activeId = event.gamepadId;
    final pauseDown = state.isPressed(gamepads.GamepadButton.start);
    final pauseWasDown = _pausePressed[event.gamepadId] ?? false;
    _pausePressed[event.gamepadId] = pauseDown;
    if (pauseDown && !pauseWasDown) {
      onPause();
      return;
    }
    _emit(state);
  }

  /// Clears a disconnected controller so no input remains stuck.
  void _onConnection(gamepads.GamepadConnectionEvent event) {
    if (_disposed ||
        event.type != gamepads.GamepadConnectionEventType.disconnected) {
      return;
    }
    _states.remove(event.gamepadId);
    _pausePressed.remove(event.gamepadId);
    if (_activeId == event.gamepadId) {
      _activeId = _states.isEmpty ? null : _states.keys.last;
    }
    final activeId = _activeId;
    _emit(activeId == null ? null : _states[activeId]);
  }

  /// Sends the active controller's current input to the race.
  void _emit(gamepads.NormalizedGamepadState? state) {
    if (state == null) {
      onChanged(GamepadControls.neutral);
      return;
    }
    final stickSteer = _deadzone(
      state.axisValue(gamepads.GamepadAxis.leftStickX),
    );
    final dpadSteer =
        (state.isPressed(gamepads.GamepadButton.dpadRight) ? 1.0 : 0.0) -
        (state.isPressed(gamepads.GamepadButton.dpadLeft) ? 1.0 : 0.0);
    onChanged(
      GamepadControls(
        steer: stickSteer.abs() >= dpadSteer.abs() ? stickSteer : dpadSteer,
        throttle:
            state.axisValue(gamepads.GamepadAxis.rightTrigger) > 0.2 ||
            state.isPressed(gamepads.GamepadButton.rightTrigger) ||
            state.isPressed(gamepads.GamepadButton.dpadUp),
        brake:
            state.axisValue(gamepads.GamepadAxis.leftTrigger) > 0.2 ||
            state.isPressed(gamepads.GamepadButton.leftTrigger) ||
            state.isPressed(gamepads.GamepadButton.dpadDown),
        attack: state.isPressed(gamepads.GamepadButton.a),
        boost: state.isPressed(gamepads.GamepadButton.x),
      ),
    );
  }

  /// Applies a centered dead zone to reduce stick drift.
  double _deadzone(double value) {
    const deadzone = 0.16;
    final magnitude = value.abs().clamp(0.0, 1.0).toDouble();
    if (magnitude <= deadzone) return 0;
    return value.sign * (magnitude - deadzone) / (1 - deadzone);
  }
}
