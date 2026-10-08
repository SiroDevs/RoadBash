// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
// import 'package:window_manager/window_manager.dart';

// Project imports:
import '../utils/app_util.dart';

Future<void> configureDisplay() async {
  if (isMobile) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } else if (isDesktop) {
    // await windowManager.ensureInitialized();
    // await windowManager.setFullScreen(true);
  }
}
