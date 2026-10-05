// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../../core/di/injectable.dart';
import '../../domain/repos/prefs_repo.dart';

/// Rider name and sound levels. Saved through [PrefsRepo].
class GameSettings extends ChangeNotifier {
  GameSettings._();

  static final GameSettings instance = GameSettings._();

  String playerName = 'Player 1';
  double master = 1.0;
  double engine = 0.8;
  double tyres = 0.8;

  /// Reads saved values. Safe to call before DI is ready (keeps defaults).
  void load() {
    try {
      final p = getIt<PrefsRepo>();
      final name = p.getPrefString(PrefConstants.playerNameKey);
      if (name.isNotEmpty) playerName = name;
      master = _vol(p, PrefConstants.masterVolKey, master);
      engine = _vol(p, PrefConstants.engineVolKey, engine);
      tyres = _vol(p, PrefConstants.tyreVolKey, tyres);
      notifyListeners();
    } catch (_) {}
  }

  double _vol(PrefsRepo p, String key, double fallback) =>
      p.keyExists(key) ? p.getPrefInt(key) / 100 : fallback;

  void update({String? name, double? master, double? engine, double? tyres}) {
    playerName = name ?? playerName;
    this.master = master ?? this.master;
    this.engine = engine ?? this.engine;
    this.tyres = tyres ?? this.tyres;
    _save();
    notifyListeners();
  }

  void _save() {
    try {
      final p = getIt<PrefsRepo>();
      p.setPrefString(PrefConstants.playerNameKey, playerName);
      p.setPrefInt(PrefConstants.masterVolKey, (master * 100).round());
      p.setPrefInt(PrefConstants.engineVolKey, (engine * 100).round());
      p.setPrefInt(PrefConstants.tyreVolKey, (tyres * 100).round());
    } catch (_) {}
  }
}
