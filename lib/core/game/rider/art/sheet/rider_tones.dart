// Project imports:
import 'art_tone.dart';

const Tone _suit = Tone(ToneRole.primary);

/// Colour role of every named rider shape, keyed by 'kind.ShapeName'.
const Map<String, Tone> riderTones = {
  'helmet.MainWrap': Tone(ToneRole.helmet),
  'helmet.Helmet': Tone(ToneRole.helmet),
  'helmet.Bottom': Tone(ToneRole.helmet, 0.78),
  'helmet.ChinArea': Tone(ToneRole.helmet, 0.68),
  'helmet.MouthArea': Tone(ToneRole.black),
  'helmet.Glass': Tone(ToneRole.visor),
  'helmet.GlassView': Tone(ToneRole.visor),
  'helmet.GlassHinge': Tone(ToneRole.gray, 0.7),
  'helmet.GlassHingeLeft': Tone(ToneRole.gray, 0.7),
  'helmet.GlassHingeRight': Tone(ToneRole.gray, 0.7),
  'helmet.GlassEdgeLeft': Tone(ToneRole.black, 1.3),
  'helmet.GlassEdgeRight': Tone(ToneRole.black, 1.3),
  'helmet.TopMost': Tone(ToneRole.trim),
  'helmet.TopFront': Tone(ToneRole.trim),
  'helmet.TopLarge': Tone(ToneRole.helmet, 1.14),
  'helmet.TopRightPart': Tone(ToneRole.helmet, 0.92),
  'helmet.TopLeftPart': Tone(ToneRole.helmet, 0.92),
  'helmet.Shape1': Tone(ToneRole.helmet, 0.93),
  'helmet.Shape2': Tone(ToneRole.helmet, 0.72),
  'helmet.Shape3': Tone(ToneRole.helmet, 1.15),
  'helmet.Shape4': Tone(ToneRole.helmet, 0.86),
  'helmet.BackPatch': Tone(ToneRole.trim),
  'helmet.BackBottomDown': Tone(ToneRole.helmet, 0.8),
  'helmet.BackBottomUp': Tone(ToneRole.helmet, 0.9),
  'helmet.BackPartDown': Tone(ToneRole.helmet, 0.8),
  'helmet.BackpartTop': Tone(ToneRole.helmet, 1.12),
  'helmet.RightPart': Tone(ToneRole.helmet, 0.7),
  'helmet.LeftPart': Tone(ToneRole.helmet, 0.7),
  'torso.Torso': _suit,
  'torso.Collar': Tone(ToneRole.neck),
  'torso.CollarFront': Tone(ToneRole.neck, 1.4),
  'torso.RightChest': Tone(ToneRole.primary, 0.86),
  'torso.LeftChest': Tone(ToneRole.primary, 1.12),
  'torso.Zip': Tone(ToneRole.black),
  'torso.ZipButton': Tone(ToneRole.metal),
  'torso.Belt': Tone(ToneRole.black),
  'torso.BeltBuckle1': Tone(ToneRole.metal, 0.9),
  'torso.BeltBuckle2': Tone(ToneRole.metal, 1.1),
  'torso.BackPart': Tone(ToneRole.primary, 0.88),
  'torso.RightShoulder': Tone(ToneRole.trim),
  'torso.LeftShoulder': Tone(ToneRole.trim),
  'arm.ArmFront': Tone(ToneRole.primary, 1.08),
  'arm.ArmSide': Tone(ToneRole.primary, 0.82),
  'arm.Glove': Tone(ToneRole.glove, 1.15),
  'arm.ArmWrist': Tone(ToneRole.glove, 1.6),
  'arm.GloveWrist': Tone(ToneRole.glove, 1.6),
  'arm.BackPart': Tone(ToneRole.glove, 1.5),
  'arm.BackPart1': Tone(ToneRole.glove, 1.5),
  'arm.BackPart2': Tone(ToneRole.glove, 1.5),
  'leg.Thigh1': Tone(ToneRole.primary, 1.12),
  'leg.Thigh2': Tone(ToneRole.primary, 0.8),
  'leg.KneePad1': Tone(ToneRole.pad, 1.5),
  'leg.KneePad2': Tone(ToneRole.pad, 0.9),
  'leg.LeftKneePad': Tone(ToneRole.pad, 1.2),
  'leg.RightKneePad': Tone(ToneRole.pad, 1.2),
  'boot.Boot': Tone(ToneRole.boot),
  'boot.Sole': Tone(ToneRole.black, 0.6),
  'boot.FrontGray': Tone(ToneRole.gray),
  'boot.GrayFront': Tone(ToneRole.gray),
};

/// Tone for shapes that are not listed, by body piece.
Tone riderToneOf(String kind, String name) {
  final listed = riderTones['$kind.$name'];
  if (listed != null) return listed;
  if (kind == 'boot') {
    return const Tone(ToneRole.black, 0.8);
  }
  if (kind == 'leg') return const Tone(ToneRole.primary, 0.92);
  if (kind == 'helmet') return const Tone(ToneRole.helmet);
  return _suit;
}
