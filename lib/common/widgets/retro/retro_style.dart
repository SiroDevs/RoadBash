// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../constants/app_constants.dart';

class Retro {
  Retro._();

  static const orange = Color(0xFFF07B3F);
  static const yellow = Color(0xFFFFE066);
  static const dim = Color(0xFFB9B9C9);
  static const panel = Color(0xAA101020);
  static const ink = Color(0xFF0A0A1F);
}

TextStyle retroBody({double size = 20, Color color = Colors.white}) =>
    TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.2,
      shadows: const [
        Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1.5, 1.5)),
      ],
    );

/// Big orange heading with a hard drop shadow.
class RetroTitle extends StatelessWidget {
  const RetroTitle(this.text, {super.key, this.size = 56});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Retro.orange,
        fontFamily: AppConstants.displayFont,
        fontSize: size,
        letterSpacing: 1,
        height: 1,
        shadows: const [Shadow(color: Colors.black, offset: Offset(4, 4))],
      ),
    );
  }
}
