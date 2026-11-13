// Dart imports:
import 'dart:ui';

// Project imports:
import '../look/rider_look.dart';
import 'art_shape.dart';
import 'art_tone.dart';
import 'rider_tones.dart';

/// Fill and outline paints for one shape.
class ShapeInk {
  ShapeInk(Color color)
    : fill = Paint()
        ..isAntiAlias = true
        ..color = color,
      edge = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4
        ..strokeJoin = StrokeJoin.round
        ..color = ToneColors.edgeOf(color);

  final Paint fill;
  final Paint edge;
}

/// Turns tones into real colours for one rider look.
class LookColors {
  LookColors(this.look, {this.forBike = false});

  final RiderLook look;
  final bool forBike;

  /// Colour of a tone for this look.
  Color of(Tone tone) => ToneColors.shaded(_base(tone.role), tone.shade);

  Color _base(ToneRole role) {
    final bike = look.bike;
    // Riders with an artwork palette are dressed as in the riding artwork,
    // so the rider looks the same on the bike, falling and running back.
    final art = forBike ? null : look.art;
    return switch (role) {
      ToneRole.primary => forBike ? bike.panel : (art?.legs ?? look.suit),
      ToneRole.jacket => forBike ? bike.panel : (art?.jacket ?? look.suit),
      ToneRole.leg => forBike ? bike.panel : (art?.legs ?? look.suit),
      ToneRole.helmet => look.helmet,
      ToneRole.trim ||
      ToneRole.accent => forBike ? bike.accent : (art?.panel ?? look.stripe),
      ToneRole.light =>
        forBike ? bike.accentEdge : (art?.sleeve ?? look.stripeEdge),
      ToneRole.dark =>
        forBike
            ? bike.panelDark
            : (art == null
                  ? look.backPatch
                  : ToneColors.shaded(art.jacket, 0.75)),
      ToneRole.graphicA => look.graphicA,
      ToneRole.graphicB => look.graphicB,
      ToneRole.knuckle => look.knuckle,
      ToneRole.neck => look.neck,
      ToneRole.glove =>
        art == null ? look.gloves : ToneColors.shaded(art.jacket, 0.7),
      ToneRole.boot => _lifted(art?.panel ?? look.boots),
      ToneRole.bootDark => ToneColors.shaded(
        art == null ? ToneColors.black : art.panel,
        art == null ? 0.8 : 0.5,
      ),
      ToneRole.visor => look.visor ?? ToneColors.visor,
      ToneRole.black => ToneColors.black,
      ToneRole.gray => ToneColors.gray,
      ToneRole.metal => forBike ? bike.trim : ToneColors.metal,
      ToneRole.pad => ToneColors.pad,
      ToneRole.plate => ToneColors.plate,
      ToneRole.lamp => bike.brakeLight,
    };
  }

  Color _lifted(Color color) =>
      color.computeLuminance() < 0.03 ? const Color(0xFF282930) : color;
}

/// An artwork part with its paints ready to draw.
class InkedPart {
  InkedPart(this.part, this.inks);

  final ArtPart part;
  final List<ShapeInk> inks;

  /// Draws every shape of the part, fading it by [alpha].
  void paint(Canvas canvas, {double alpha = 1}) {
    if (alpha <= 0.01) return;
    for (var index = 0; index < inks.length; index++) {
      final ink = inks[index];
      final path = part.shapes[index].path;
      if (alpha >= 0.99) {
        canvas.drawPath(path, ink.fill);
        canvas.drawPath(path, ink.edge);
        continue;
      }
      final fade = Paint()
        ..isAntiAlias = true
        ..color = ink.fill.color.withValues(alpha: alpha);
      canvas.drawPath(path, fade);
    }
  }

  /// Paints every shape after mapping its points through a continuous pose.
  void paintMapped(Canvas canvas, Offset Function(Offset point) mapPoint) {
    for (var index = 0; index < inks.length; index++) {
      final points = part.shapes[index].points;
      final first = mapPoint(points.first);
      final path = Path()..moveTo(first.dx, first.dy);
      for (final point in points.skip(1)) {
        final mapped = mapPoint(point);
        path.lineTo(mapped.dx, mapped.dy);
      }
      path.close();
      canvas.drawPath(path, inks[index].fill);
      canvas.drawPath(path, inks[index].edge);
    }
  }
}

/// A whole artwork sheet coloured for one look.
class InkedSheet {
  InkedSheet.rider(this.sheet, RiderLook look)
    : parts = {
        for (final part in sheet.parts.values)
          part.id: InkedPart(part, [
            for (final shape in part.shapes)
              ShapeInk(LookColors(look).of(riderToneOf(part.kind, shape.name))),
          ]),
      };

  final ArtSheet sheet;
  final Map<String, InkedPart> parts;

  /// Returns the coloured part with this id.
  InkedPart part(String id) => parts[id]!;

  /// Returns a joint position of the sheet.
  Offset anchor(String name) => sheet.anchor(name);
}
