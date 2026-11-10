// Flutter imports:
import 'package:flutter/painting.dart';

/// The colour roles a shape can take from a rider or bike look.
enum ToneRole {
  primary,
  helmet,
  trim,
  neck,
  glove,
  boot,
  visor,
  black,
  gray,
  metal,
  pad,
  plate,
  lamp,
}

/// A colour role and how much lighter or darker the shape is drawn.
class Tone {
  const Tone(this.role, [this.shade = 1.0]);

  final ToneRole role;
  final double shade;
}

/// Fixed colours shared by every look.
class ToneColors {
  static const Color visor = Color(0xFF1C2A3A);
  static const Color black = Color(0xFF16171C);
  static const Color gray = Color(0xFF787C84);
  static const Color metal = Color(0xFFAAAEB6);
  static const Color pad = Color(0xFF282830);
  static const Color plate = Color(0xFFE8E6DC);

  /// Scales the lightness of a colour.
  static Color shaded(Color color, double factor) {
    if (factor == 1.0) return color;
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness * factor).clamp(0.0, 1.0).toDouble())
        .toColor();
  }

  /// The outline colour drawn around a filled shape.
  static Color edgeOf(Color fill) => shaded(fill, 0.45);
}
