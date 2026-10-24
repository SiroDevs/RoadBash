// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'responsive_layout_builder.dart';

/// Every size the menu screens use, per layout size (the same idea as
/// Tupange's `BoardSize`). [large] holds the original desktop values.
/// Screens read these through `context.sizes` instead of hard-coding numbers.
class RetroSizes {
  const RetroSizes._({
    required this.pad,
    required this.infoPad,
    required this.gap,
    required this.gapSmall,
    required this.title,
    required this.body,
    required this.small,
    required this.caption,
    required this.icon,
    required this.menuItemV,
    required this.buttonText,
    required this.buttonH,
    required this.buttonV,
    required this.logo,
    required this.presents,
    required this.tagline,
    required this.rights,
    required this.noticeTitle,
    required this.noticeBody,
    required this.noticeGap,
    required this.resultRow,
    required this.resultPlaceW,
    required this.resultTimeW,
    required this.labelW,
    required this.cardMaxW,
  });

  final double pad, infoPad, gap, gapSmall;
  final double title, body, small, caption, icon;
  final double menuItemV, buttonText, buttonH, buttonV;
  final double logo, presents, tagline, rights;
  final double noticeTitle, noticeBody, noticeGap;
  final double resultRow, resultPlaceW, resultTimeW;
  final double labelW, cardMaxW;

  static const RetroSizes smallSizes = RetroSizes._(
    pad: 14,
    infoPad: 14,
    gap: 10,
    gapSmall: 6,
    title: 32,
    body: 17,
    small: 15,
    caption: 13,
    icon: 16,
    menuItemV: 9,
    buttonText: 15,
    buttonH: 20,
    buttonV: 11,
    logo: 64,
    presents: 28,
    tagline: 22,
    rights: 13,
    noticeTitle: 34,
    noticeBody: 20,
    noticeGap: 32,
    resultRow: 19,
    resultPlaceW: 38,
    resultTimeW: 92,
    labelW: 84,
    cardMaxW: 340,
  );

  static const RetroSizes mediumSizes = RetroSizes._(
    pad: 18,
    infoPad: 18,
    gap: 12,
    gapSmall: 6,
    title: 40,
    body: 19,
    small: 17,
    caption: 15,
    icon: 18,
    menuItemV: 7,
    buttonText: 16,
    buttonH: 22,
    buttonV: 10,
    logo: 84,
    presents: 46,
    tagline: 32,
    rights: 20,
    noticeTitle: 44,
    noticeBody: 28,
    noticeGap: 48,
    resultRow: 23,
    resultPlaceW: 46,
    resultTimeW: 108,
    labelW: 96,
    cardMaxW: 420,
  );

  static const RetroSizes largeSizes = RetroSizes._(
    pad: 24,
    infoPad: 28,
    gap: 16,
    gapSmall: 8,
    title: 56,
    body: 24,
    small: 22,
    caption: 20,
    icon: 20,
    menuItemV: 10,
    buttonText: 20,
    buttonH: 28,
    buttonV: 14,
    logo: 120,
    presents: 75,
    tagline: 50,
    rights: 30,
    noticeTitle: 65,
    noticeBody: 40,
    noticeGap: 75,
    resultRow: 28,
    resultPlaceW: 56,
    resultTimeW: 130,
    labelW: 110,
    cardMaxW: 520,
  );

  static RetroSizes forLayout(ResponsiveLayoutSize size) => size.pick(
    small: smallSizes,
    medium: mediumSizes,
    large: largeSizes,
  );

  static RetroSizes of(BuildContext context) => forLayout(context.layoutSize);
}

extension RetroSizesContext on BuildContext {
  RetroSizes get sizes => RetroSizes.of(this);
}
