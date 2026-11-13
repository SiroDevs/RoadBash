// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../utils/canvas_text.dart';
import 'handlebar_art.dart';
import 'handlebar_config.dart';
import 'handlebar_rig.dart';

/// Both handlebar grips and their labels, drawn above everything else so they
/// are always visible and easy to find with a thumb.
class HandlebarGripsHud extends Component {
  HandlebarGripsHud(this.rig, this.gasLabel) : super(priority: 20);

  final HandlebarRig rig;
  final String gasLabel;

  static const _labelColor = Color(0xFFFFFFFF);
  static const _gasFill = Color(0xFF3DBB5A);
  static const double _labelSize = 0.6;

  @override
  void render(Canvas canvas) {
    rig.inArtSpace(canvas, (layout) {
      final extension = layout.pipeExtension;
      rig.art.paintLeftGrip(
        canvas,
        extension: extension,
        fill: rig.leftGasOn ? _gasFill : HandlebarArt.color000000,
      );
      rig.art.paintRightGrip(
        canvas,
        extension: extension,
        fill: rig.rightGasOn ? _gasFill : HandlebarArt.color000000,
      );
    });
    _paintGasLabels(canvas);
  }

  /// Prints the gas label on both grips, turned with the handlebar.
  void _paintGasLabels(Canvas canvas) {
    _paintGripLabel(canvas, gasLabel, HandlebarArt.leftGripCentre, false);
    _paintGripLabel(canvas, gasLabel, HandlebarArt.rightGripCentre, true);
  }

  void _paintGripLabel(
    Canvas canvas,
    String label,
    Offset gripCentre,
    bool rightSide,
  ) {
    final layout = rig.layout;
    if (layout == null) return;
    final extension = layout.pipeExtension / 2;
    final centre = rig.toScreen(
      Offset(
        gripCentre.dx + (rightSide ? extension : -extension),
        gripCentre.dy,
      ),
    );
    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.rotate(rig.angle);
    paintText(
      canvas,
      label.toUpperCase(),
      Offset.zero,
      (HandlebarArt.gripThickness + HandlebarConfig.gripThicken) *
          layout.artScale *
          _labelSize,
      _labelColor,
      weight: FontWeight.w800,
    );
    canvas.restore();
  }
}
