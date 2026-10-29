// Flutter imports:
import 'package:flutter/foundation.dart' show kIsWeb;

// Project imports:
import '../../../utils/app_util.dart';

/// Road drawing constants.
abstract final class RoadConfig {
  static final bool _lite = kIsWeb && isTouchDevice;

  static const double segmentLength = 200;
  static const double roadWidth = 2000;
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84;
  static const double horizonRatio = 0.42;
  static final int drawDistance = _lite ? 170 : 240;
  static final int decorDistance = _lite ? 130 : 200;
  static const int rumbleLength = 4;

  static const double nearClip = 200;

  static const int maxPropDepth = 26;

  static const double fogStart = 0.17;
  static const double fogEnd = 0.72;
  static const int fogSteps = 28;

  static const double shoulder = 0.13;
  static const double medianWidth = 0.42;
  static const double oppositeWidth = 2.0;
  static const double unitKm = 0.0000044;
}