// Project imports:
import 'art_tone.dart';

/// Colour role of every named bike shape.
const Map<String, Tone> bikeTones = {
  'BikeFrame': Tone(ToneRole.primary, 0.55),
  'BackSeatFrame': Tone(ToneRole.black, 1.3),
  'NumberPlatePanel': Tone(ToneRole.plate),
  'BackLight': Tone(ToneRole.lamp),
  'LeftMidPanel': Tone(ToneRole.primary),
  'RightMidPanel': Tone(ToneRole.primary, 0.85),
  'BigUnderPanel': Tone(ToneRole.primary, 0.9),
  'LowerUnderBody': Tone(ToneRole.black, 1.4),
  'LowerSidePanel': Tone(ToneRole.primary, 0.85),
  'UpperSidePanel': Tone(ToneRole.primary, 1.1),
  'TopSidePanel': Tone(ToneRole.primary, 0.95),
  'LeftBackPipe': Tone(ToneRole.metal, 0.8),
  'RightBackPipe': Tone(ToneRole.metal, 0.8),
  'Chain': Tone(ToneRole.gray, 0.6),
  'ChainSidePanel': Tone(ToneRole.gray, 0.45),
  'LeftSideStepper': Tone(ToneRole.metal, 0.9),
  'RightSideStepper': Tone(ToneRole.metal, 0.9),
  'HandleBar': Tone(ToneRole.black, 1.9),
  'LeftGrip': Tone(ToneRole.black, 0.8),
  'RightGrip': Tone(ToneRole.black, 0.8),
  'LeftSideMirror': Tone(ToneRole.black, 1.6),
  'RightSideMirror': Tone(ToneRole.black, 1.6),
  'FrontShield': Tone(ToneRole.primary, 1.08),
  'LeftFrontShieldPipe': Tone(ToneRole.metal, 0.7),
  'RightFrontShieldPipe': Tone(ToneRole.metal, 0.7),
  'Tyre': Tone(ToneRole.black, 0.9),
  'TyreWall': Tone(ToneRole.gray, 0.5),
  'Exhaust': Tone(ToneRole.metal),
  'ExhaustOuterHole': Tone(ToneRole.black, 1.9),
  'ExhaustInnerHole': Tone(ToneRole.black, 0.4),
};

/// Tone for bike shapes that are not listed.
Tone bikeToneOf(String name) => bikeTones[name] ?? const Tone(ToneRole.primary);
