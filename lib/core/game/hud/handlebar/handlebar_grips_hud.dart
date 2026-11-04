// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../utils/canvas_text.dart';
import 'handlebar_art.dart';
import 'handlebar_rig.dart';

/// Both handlebar grips and their labels, drawn above everything else so they
/// are always visible and easy to find with a thumb.
class HandlebarGripsHud extends Component {
  HandlebarGripsHud(this.rig, this.gasLabel) : super(priority: 20);

  final HandlebarRig rig;
  final String gasLabel;

  static const _labelColor = Color(0xFFFFFFFF);
  static const _heldFill = Color(0xFF666666);
  static const _gasFill = Color(0xFF3DBB5A);
  static const double _labelSize = 0.7;

  @override
  void render(Canvas canvas) {
    rig.inArtSpace(canvas, (layout) {
      final extension = layout.pipeExtension;
      rig.art.paintLeftGrip(
        canvas,
        extension: extension,
        fill: rig.leftHeld ? _heldFill : HandlebarArt.color000000,
      );
      rig.art.paintRightGrip(
        canvas,
        extension: extension,
        fill: rig.gasOn ? _gasFill : HandlebarArt.color000000,
      );
    });
    _paintGasLabel(canvas);
  }

  /// Prints the gas label on the right grip, turned the way the grip is.
  void _paintGasLabel(Canvas canvas) {
    final layout = rig.layout;
    if (layout == null) return;
    final centre = rig.toScreen(
      Offset(
        HandlebarArt.rightGripCentre.dx + layout.pipeExtension / 2,
        HandlebarArt.rightGripCentre.dy,
      ),
    );
    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.rotate(rig.angle + HandlebarArt.rightGripTilt);
    paintText(
      canvas,
      gasLabel.toUpperCase(),
      Offset.zero,
      HandlebarArt.gripThickness * layout.artScale * _labelSize,
      _labelColor,
      weight: FontWeight.w800,
    );
    canvas.restore();
  }
}