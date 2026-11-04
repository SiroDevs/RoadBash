// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'handlebar_rig.dart';

/// The handlebar pipe, drawn behind the dashboard.
class HandlebarPipeHud extends Component {
  HandlebarPipeHud(this.rig) : super(priority: 9);

  final HandlebarRig rig;

  @override
  void render(Canvas canvas) {
    rig.inArtSpace(
      canvas,
      (layout) => rig.art.paintPipe(canvas, extension: layout.pipeExtension),
    );
  }
}