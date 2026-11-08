// Project imports:
import '../models/career.dart';

/// Contract for loading and saving the player's career on this device.
///
/// The level is never stored here: it lives on the player's account. Only the
/// win streak and best times are kept, separately for each [account].
abstract interface class CareerRepo {
  Future<Career> load(String account);
  Future<void> save(String account, Career career);
}
