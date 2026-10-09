// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/progress/progress_cubit.dart';
import '../../../core/settings/settings_cubit.dart';

@injectable
class SplashCubit extends Cubit<bool> {
  SplashCubit(this._settings, this._progress) : super(false);

  final SettingsCubit _settings;
  final ProgressCubit _progress;
  final Completer<void> _skip = Completer<void>();

  Future<void> start() async {
    await Future.wait([
      _settings.load(),
      _progress.load(),
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
