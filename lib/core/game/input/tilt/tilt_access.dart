// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../../../../domain/models/player_profile.dart';
import '../../../utils/app_util.dart';
import 'tilt_source.dart';

/// Whether the tilt sensor can be read.
enum TiltAccessStatus { unknown, granted, notGranted, notNeeded }

/// Shares one tilt sensor for the whole session.
///
/// Browsers on phones only give motion access to a page after the player
/// agrees, and the answer is lost when the tab closes. Asking early, as soon
/// as the player leaves the notice screen, means tilt already works when the
/// first race starts and keeps working in every race after it.
class TiltAccess {
  TiltAccess._();

  static final TiltAccess instance = TiltAccess._();

  final ValueNotifier<TiltAccessStatus> status = ValueNotifier(
    TiltAccessStatus.unknown,
  );

  TiltSource? _source;
  Future<TiltAccessStatus>? _pending;

  /// The shared tilt source, created on first use.
  TiltSource get source => _source ??= createTiltSource();

  /// True when tilt samples can be read right now.
  bool get ready =>
      status.value == TiltAccessStatus.granted ||
      status.value == TiltAccessStatus.notNeeded;

  /// Asks for tilt access when the platform needs it.
  ///
  /// Safe to call often: it returns at once when access is already given and
  /// never shows two prompts together. Browsers only show the prompt while
  /// handling a tap, so call it from a tap handler where possible. A refusal
  /// is not final, because a call made outside a tap is refused too.
  Future<TiltAccessStatus> request() =>
      _pending ??= _ask().whenComplete(() => _pending = null);

  /// Asks for access early on phone browsers whose player steers by tilting.
  Future<void> prepareFor(PlayerProfile profile) async {
    if (!kIsWeb || !isTouchDevice || profile.useScreenTouch) return;
    await request();
  }

  /// Does the actual asking and records the answer.
  Future<TiltAccessStatus> _ask() async {
    if (ready) return status.value;
    final shared = source;
    if (!shared.needsPermission) {
      return status.value = TiltAccessStatus.notNeeded;
    }
    final granted = await shared.requestPermission();
    return status.value =
        granted ? TiltAccessStatus.granted : TiltAccessStatus.notGranted;
  }
}
