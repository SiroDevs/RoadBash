// Project imports:
import 'art_tone.dart';

/// Colour role of every named bike shape.
const Map<String, Tone> bikeTones = {
  'BikeFrame': Tone(ToneRole.accent, 0.5),
  'BackSeatFrame': Tone(ToneRole.black, 1.3),
  'NumberPlatePanel': Tone(ToneRole.plate),
  'BackLight': Tone(ToneRole.lamp),
  'LeftMidPanel': Tone(ToneRole.primary, 1.25),
  'RightMidPanel': Tone(ToneRole.primary, 1.1),
  'BigUnderPanel': Tone(ToneRole.primary, 0.8),
  'LowerUnderBody': Tone(ToneRole.black, 1.4),
  'LowerSidePanel': Tone(ToneRole.accent, 0.8),
  'UpperSidePanel': Tone(ToneRole.primary, 1.2),
  'TopSidePanel': Tone(ToneRole.primary, 1.05),
  'LeftBackPipe': Tone(ToneRole.accent),
  'RightBackPipe': Tone(ToneRole.accent),
  'Chain': Tone(ToneRole.gray, 0.6),
  'ChainSidePanel': Tone(ToneRole.gray, 0.45),
  'LeftSideStepper': Tone(ToneRole.metal, 0.9),
  'RightSideStepper': Tone(ToneRole.metal, 0.9),
  'HandleBar': Tone(ToneRole.black, 1.9),
  'LeftGrip': Tone(ToneRole.black, 0.8),
  'RightGrip': Tone(ToneRole.black, 0.8),
  'LeftSideMirror': Tone(ToneRole.dark, 1.3),
  'RightSideMirror': Tone(ToneRole.dark, 1.3),
  'FrontShield': Tone(ToneRole.light, 0.6),
  'LeftFrontShieldPipe': Tone(ToneRole.accent, 0.9),
  'RightFrontShieldPipe': Tone(ToneRole.accent, 0.9),
  'Tyre': Tone(ToneRole.black, 0.9),
  'TyreWall': Tone(ToneRole.gray, 0.5),
  'Exhaust': Tone(ToneRole.metal),
  'ExhaustOuterHole': Tone(ToneRole.black, 1.9),
  'ExhaustInnerHole': Tone(ToneRole.black, 0.4),
};

/// Tone for bike shapes that are not listed.
Tone bikeToneOf(String name) => bikeTones[name] ?? const Tone(ToneRole.primary);
