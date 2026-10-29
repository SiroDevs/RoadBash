// Flutter imports:
import 'package:flutter/widgets.dart';

/// Turns whatever is under it black and white.
const ColorFilter retroGrayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

/// [child] in black and white when [on], untouched otherwise.
Widget grayscaleIf(bool on, Widget child) =>
    on ? ColorFiltered(colorFilter: retroGrayscale, child: child) : child;
