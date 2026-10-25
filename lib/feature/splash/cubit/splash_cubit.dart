// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/auth/auth_cubit.dart';
import '../../../core/progress/progress_cubit.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../domain/repos/stats_repo.dart';

@injectable
class SplashCubit extends Cubit<bool> {
  SplashCubit(this._settings, this._progress, this._stats, this._auth)
    : super(false);

  final SettingsCubit _settings;
  final ProgressCubit _progress;
  final StatsRepo _stats;
  final AuthCubit _auth;
  final Completer<void> _skip = Completer<void>();

  Future<void> start() async {
    unawaited(_stats.trackVisit());
    await _settings.load();
    await _auth.restore();
    await Future.wait([
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