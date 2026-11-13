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
  HandlebarGripsHud(this.rig, this.gasLabel, {this.attackLabel})
    : super(priority: 20);

  final HandlebarRig rig;
  final String gasLabel;
  final String? attackLabel;

  static const _labelColor = Color(0xFFFFFFFF);
  static const _heldFill = Color(0xFF666666);
  static const _gasFill = Color(0xFF3DBB5A);
  static const _attackFill = Color(0xFF8E241D);
  static const double _labelSize = 0.6;

  @override
  void render(Canvas canvas) {
    rig.inArtSpace(canvas, (layout) {
      final extension = layout.pipeExtension;
      final leftFill = attackLabel == null
          ? (rig.leftHeld ? _heldFill : HandlebarArt.color000000)
          : (rig.leftHeld ? _attackFill : const Color(0xFF4D1410));
      rig.art.paintLeftGrip(canvas, extension: extension, fill: leftFill);
      rig.art.paintRightGrip(
        canvas,
        extension: extension,
        fill: rig.gasOn ? _gasFill : HandlebarArt.color000000,
      );
    });
    _paintGasLabel(canvas);
    _paintAttackLabel(canvas);
  }

  /// Prints the gas label on the right grip, turned with the handlebar.
  void _paintGasLabel(Canvas canvas) {
    _paintGripLabel(canvas, gasLabel, HandlebarArt.rightGripCentre, true);
  }

  /// Prints the attack label on the left grip when combat is unlocked.
  void _paintAttackLabel(Canvas canvas) {
    final label = attackLabel;
    if (label != null) {
      _paintGripLabel(canvas, label, HandlebarArt.leftGripCentre, false);
    }
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
