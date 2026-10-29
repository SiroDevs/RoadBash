import 'dart:ui';

import 'package:flutter/painting.dart';

import 'bike_look.dart';

class RiderLook {
  const RiderLook({
    this.suit = const Color(0xFFA349A4),
    this.stripe = const Color(0xFF22B14C),
    this.stripeEdge = const Color(0xFFB5E61D),
    this.backPatch = const Color(0xFF880015),
    this.helmet = const Color(0xFFF2C21C),
    this.helmetShadeOverride,
    this.neck = const Color(0xFF23242B),
    this.gloves = const Color(0xFF23242B),
    this.boots = const Color(0xFF000000),
    this.bike = BikeLook.stock,
  });

  static const RiderLook main = RiderLook();

  final Color suit;
  final Color stripe;
  final Color stripeEdge;
  final Color backPatch;
  final Color helmet;
  final Color? helmetShadeOverride;
  final Color neck;
  final Color gloves;
  final Color boots;
  final BikeLook bike;

  static const Color helmetGloss = Color(0x66FFFFFF);

  Color get helmetShade {
    final o = helmetShadeOverride;
    if (o != null) return o;
    final hsl = HSLColor.fromColor(helmet);
    return hsl.withLightness((hsl.lightness * 0.77).clamp(0.0, 1.0)).toColor();
  }

  RiderLook copyWith({
    Color? suit,
    Color? stripe,
    Color? stripeEdge,
    Color? backPatch,
    Color? helmet,
    Color? helmetShadeOverride,
    Color? neck,
    Color? gloves,
    Color? boots,
    BikeLook? bike,
  }) => RiderLook(
    suit: suit ?? this.suit,
    stripe: stripe ?? this.stripe,
    stripeEdge: stripeEdge ?? this.stripeEdge,
    backPatch: backPatch ?? this.backPatch,
    helmet: helmet ?? this.helmet,
    helmetShadeOverride: helmetShadeOverride ?? this.helmetShadeOverride,
    neck: neck ?? this.neck,
    gloves: gloves ?? this.gloves,
    boots: boots ?? this.boots,
    bike: bike ?? this.bike,
  );
}
