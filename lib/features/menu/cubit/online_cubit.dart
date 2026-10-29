// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/repos/stats_repo.dart';

/// Polls the number of players online.
@injectable
class OnlineCubit extends Cubit<int?> {
  OnlineCubit(this._repo) : super(null);

  final StatsRepo _repo;
  Timer? _timer;

  /// Fetches the online count now and then every 20 seconds.
  void start() {
    _fetch();
    _timer ??= Timer.periodic(const Duration(seconds: 20), (_) => _fetch());
  }

  /// Fetches the online count and emits it, ignoring failures.
  Future<void> _fetch() async {
    try {
      final count = await _repo.onlineCount();
      if (!isClosed) emit(count);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
