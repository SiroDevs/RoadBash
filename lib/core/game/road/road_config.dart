abstract final class RoadConfig {
  static const double segmentLength = 200;

  /// Half the tarmac width, in world units. The road spans +/- this.
  static const double roadWidth = 2000;
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84;
  static const double horizonRatio = 0.42;
  static const int drawDistance = 240;
  static const int decorDistance = 200;
  static const int rumbleLength = 4;

  /// Road closer than this is clipped, not projected: a near-zero depth
  /// makes polygons millions of pixels wide, which corrupts GPU rendering.
  static const double nearClip = 200;

  /// Scenery deeper than this many segments is never anchored, which bounds
  /// how far back the prop scan has to start.
  static const int maxPropDepth = 26;

  /// Where the haze starts and finishes eating the road, as a fraction of
  /// [drawDistance]. Past [fogEnd] a segment is pure haze, which is what the
  /// backdrop already paints, so the render loop stops there.
  static const double fogStart = 0.17;
  static const double fogEnd = 0.72;

  /// Quantisation of the fog ramp. Colours are pre-blended into this many
  /// steps at startup so no frame ever allocates a Paint.
  static const int fogSteps = 28;

  static const double maxSpeed = segmentLength * 60;
  static const double topSpeedKmh = 240;
  static const double accel = maxSpeed / 5.4;
  static const double braking = -maxSpeed * 1.1;
  static const double decel = -maxSpeed / 3.4;
  static const double offRoadDecel = -maxSpeed / 2;
  static const double offRoadLimit = maxSpeed / 4;
  static const double stoppedSpeed = maxSpeed * 0.02;

  /// How fast the steering input ramps toward the key/stick position, and
  /// how fast it falls back to centre. Raw +/-1 steering snaps the bike.
  static const double steerAttack = 5.0;
  static const double steerRelease = 7.5;

  /// Lateral road-widths per second at full lock. Scaled down as speed
  /// rises so the bike settles instead of darting across lanes.
  static const double steerRate = 1.9;
  static const double steerHighSpeedDamp = 0.45;

  /// Sideways pull through a bend, per unit of curve.
  static const double centrifugal = 0.22;

  /// How far off the tarmac the bike may stray before it is held.
  static const double maxOffRoad = 1.45;

  /// Dirt/kerb shoulder either side, in half-road-widths.
  static const double shoulder = 0.13;

  /// One world unit in kilometres, for the "Length" label only.
  static const double unitKm = 0.0000044;
}
