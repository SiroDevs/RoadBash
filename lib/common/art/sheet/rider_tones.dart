// Project imports:
import 'art_tone.dart';

const Tone _suit = Tone(ToneRole.primary);

/// Colour role of every named rider shape, keyed by 'kind.ShapeName'.
const Map<String, Tone> riderTones = {
  'helmet.MainWrap': Tone(ToneRole.helmet),
  'helmet.Helmet': Tone(ToneRole.helmet),
  'helmet.Bottom': Tone(ToneRole.helmet, 1.4),
  'helmet.ChinArea': Tone(ToneRole.helmet, 1.2),
  'helmet.MouthArea': Tone(ToneRole.black),
  'helmet.Glass': Tone(ToneRole.visor),
  'helmet.GlassView': Tone(ToneRole.visor),
  'helmet.GlassHinge': Tone(ToneRole.gray, 0.7),
  'helmet.GlassHingeLeft': Tone(ToneRole.gray, 0.7),
  'helmet.GlassHingeRight': Tone(ToneRole.gray, 0.7),
  'helmet.GlassEdgeLeft': Tone(ToneRole.black, 1.3),
  'helmet.GlassEdgeRight': Tone(ToneRole.black, 1.3),
  'helmet.TopMost': Tone(ToneRole.graphicA),
  'helmet.TopFront': Tone(ToneRole.graphicA, 1.1),
  'helmet.TopLarge': Tone(ToneRole.graphicB),
  'helmet.TopRightPart': Tone(ToneRole.graphicA, 0.85),
  'helmet.TopLeftPart': Tone(ToneRole.graphicA, 0.85),
  'helmet.Shape1': Tone(ToneRole.graphicB, 0.9),
  'helmet.Shape2': Tone(ToneRole.graphicA, 0.8),
  'helmet.Shape3': Tone(ToneRole.graphicA),
  'helmet.Shape4': Tone(ToneRole.helmet, 1.5),
  'helmet.BackPatch': Tone(ToneRole.graphicB),
  'helmet.BackBottomDown': Tone(ToneRole.graphicA, 0.8),
  'helmet.BackBottomUp': Tone(ToneRole.graphicB, 0.9),
  'helmet.BackPartDown': Tone(ToneRole.graphicA, 0.8),
  'helmet.BackpartTop': Tone(ToneRole.graphicB),
  'helmet.RightPart': Tone(ToneRole.graphicA, 0.75),
  'helmet.LeftPart': Tone(ToneRole.graphicB, 0.75),
  'torso.Torso': _suit,
  'torso.Collar': Tone(ToneRole.accent),
  'torso.CollarFront': Tone(ToneRole.neck, 1.4),
  'torso.RightChest': Tone(ToneRole.dark, 1.0),
  'torso.LeftChest': Tone(ToneRole.dark, 1.15),
  'torso.Zip': Tone(ToneRole.black),
  'torso.ZipButton': Tone(ToneRole.metal),
  'torso.Belt': Tone(ToneRole.black),
  'torso.BeltBuckle1': Tone(ToneRole.metal, 0.9),
  'torso.BeltBuckle2': Tone(ToneRole.metal, 1.1),
  'torso.BackPart': Tone(ToneRole.dark, 0.95),
  'torso.RightShoulder': Tone(ToneRole.accent),
  'torso.LeftShoulder': Tone(ToneRole.accent),
  'arm.ArmFront': Tone(ToneRole.accent),
  'arm.ArmSide': Tone(ToneRole.light),
  'arm.Glove': Tone(ToneRole.glove),
  'arm.ArmWrist': Tone(ToneRole.glove, 0.8),
  'arm.GloveWrist': Tone(ToneRole.glove, 0.8),
  'arm.BackPart': Tone(ToneRole.knuckle),
  'arm.BackPart1': Tone(ToneRole.knuckle),
  'arm.BackPart2': Tone(ToneRole.knuckle, 0.85),
  'leg.Thigh1': Tone(ToneRole.accent),
  'leg.Thigh2': Tone(ToneRole.light),
  'leg.KneePad1': Tone(ToneRole.accent, 1.2),
  'leg.KneePad2': Tone(ToneRole.accent, 0.8),
  'leg.LeftKneePad': Tone(ToneRole.accent),
  'leg.RightKneePad': Tone(ToneRole.accent),
  'boot.Boot': Tone(ToneRole.boot),
  'boot.Sole': Tone(ToneRole.black, 0.6),
  'boot.FrontGray': Tone(ToneRole.gray),
  'boot.GrayFront': Tone(ToneRole.gray),
  'arm.FullHand': Tone(ToneRole.glove),
  'arm.Hand': Tone(ToneRole.glove),
  'arm.LeftHand': Tone(ToneRole.glove),
  'arm.RightHand': Tone(ToneRole.glove),
  'leg.FullLeg': Tone(ToneRole.primary, 0.92),
  'leg.Leg': Tone(ToneRole.primary, 0.92),
  'leg.LeftLeg': Tone(ToneRole.primary, 0.92),
  'leg.RightLeg': Tone(ToneRole.primary, 0.92),
  'boot.LeftBoot': Tone(ToneRole.boot),
  'boot.RightBoot': Tone(ToneRole.boot),
  'boot.BackBlack': Tone(ToneRole.black, 0.8),
  'boot.BlackBack': Tone(ToneRole.black, 0.8),
  'boot.BlackFront': Tone(ToneRole.black, 0.8),
  'boot.BlackPatch': Tone(ToneRole.black, 0.8),
  'boot.BlackSide': Tone(ToneRole.black, 0.8),
  'boot.FrontBlack': Tone(ToneRole.black, 0.8),
  'boot.SideBlack': Tone(ToneRole.black, 0.8),
  'boot.SmallBlack': Tone(ToneRole.black, 0.8),
  'boot.SmallPatch': Tone(ToneRole.black, 0.8),
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
