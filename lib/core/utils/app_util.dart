// Dart imports:
import 'dart:developer' as logging show log;

// Flutter imports:
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// True on desktop platforms.
bool get isDesktop =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);

/// True on touch devices.
bool get isTouchDevice =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// True on mobile platforms.
bool get isMobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.fuchsia);

/// Writes a message to the log.
void logger(String message) {
  return logging.log('''
$message
  ''');
}
