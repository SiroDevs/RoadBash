abstract final class RoadConfig {
  static const double segmentLength = 200;
  static const double roadWidth = 2000;
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84;
  static const double horizonRatio = 0.42;
  static const int drawDistance = 240;
  static const int decorDistance = 200;
  static const int rumbleLength = 4;

  // Near-zero depth makes polygons huge and corrupts GPU rendering.
  static const double nearClip = 200;

  static const int maxPropDepth = 26;

  static const double fogStart = 0.17;
  static const double fogEnd = 0.72;
  static const int fogSteps = 28;

  static const double shoulder = 0.13;
  static const double unitKm = 0.0000044;
}
