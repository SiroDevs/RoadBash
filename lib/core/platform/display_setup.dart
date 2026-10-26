// Flutter imports:
import 'package:flutter/services.dart';

// Project imports:
import '../utils/app_util.dart';

// Package imports:

Future<void> configureDisplay() async {
  if (isMobile) {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } else if (isDesktop) {
  }
}
