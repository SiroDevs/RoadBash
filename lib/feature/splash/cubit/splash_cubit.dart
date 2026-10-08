// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
// import '../../progress/cubit/progress_cubit.dart';
// import '../../settings/cubit/settings_cubit.dart';

@injectable
class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(false);

  // final SettingsCubit _settings;
  // final ProgressCubit _progress;
  final Completer<void> _skip = Completer<void>();

  Future<void> start() async {
    await Future.wait([
      // _settings.load(),
      // _progress.load(),
      Future.any([
        Future<void>.delayed(const Duration(milliseconds: 2800)),
        _skip.future,
      ]),
    ]);
    if (!isClosed) emit(true);
  }

  void skip() {
    if (!_skip.isCompleted) _skip.complete();
  }
}
