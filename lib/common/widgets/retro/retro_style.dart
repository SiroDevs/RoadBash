// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/constants/app_constants.dart';
import '../../layout/retro_sizes.dart';

/// Colors and styles of the retro look.
class Retro {
  Retro._();

  static const red = Color(0xFFFF0000);
  static const orange = Color(0xFFF07B3F);
  static const yellow = Color(0xFFFFE066);
  static const dim = Color(0xFFB9B9C9);
  static const panel = Color(0xAA101020);
  static const ink = Color(0xFF0A0A1F);
}

/// Returns the retro body text style.
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

/// Retro-styled title text.
class RetroTitle extends StatelessWidget {
  const RetroTitle(this.text, {super.key, this.size});

  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final fontSize = size ?? context.sizes.title;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        style: TextStyle(
          color: Retro.orange,
          fontFamily: AppConstants.displayFont,
          fontSize: fontSize,
          letterSpacing: 1,
          height: 1,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(fontSize * 0.07, fontSize * 0.07),
            ),
          ],
        ),
      ),
    );
  }
}
