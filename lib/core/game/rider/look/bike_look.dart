// Dart imports:
import 'dart:ui';

class BikeLook {
  const BikeLook({
    this.frame = const Color(0xFF000000),
    this.panel = const Color(0xFFC3C3C3),
    this.panelDark = const Color(0xFF7F7F7F),
    this.accent = const Color(0xFF22B14C),
    this.accentEdge = const Color(0xFFB5E61D),
    this.trim = const Color(0xFFEFE4B0),
    this.brakeLight = const Color(0xFFED1C24),
  });

  static const BikeLook stock = BikeLook();

  final Color frame;
  final Color panel;
  final Color panelDark;
  final Color accent;
  final Color accentEdge;
  final Color trim;
  final Color brakeLight;

  BikeLook copyWith({
    Color? frame,
    Color? panel,
    Color? panelDark,
    Color? accent,
    Color? accentEdge,
    Color? trim,
    Color? brakeLight,
  }) => BikeLook(
    frame: frame ?? this.frame,
    panel: panel ?? this.panel,
    panelDark: panelDark ?? this.panelDark,
    accent: accent ?? this.accent,
    accentEdge: accentEdge ?? this.accentEdge,
    trim: trim ?? this.trim,
    brakeLight: brakeLight ?? this.brakeLight,
  );
}
