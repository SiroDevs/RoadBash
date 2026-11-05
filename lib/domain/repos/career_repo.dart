// Project imports:
import '../models/career.dart';

/// Contract for loading and saving the player's career.
abstract interface class CareerRepo {
  Future<Career> load();
  Future<void> save(Career career);
}
