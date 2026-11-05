// Package imports:
import 'package:equatable/equatable.dart';

/// How a race ended for the player's wallet.
enum RaceEnd { finished, busted, crashed }

/// What a race paid or cost, in shillings, and the wallet balance after it.
///
/// The prize and the two bonuses are paid for a win; the fine, the traffic
/// fines and the hospital and garage bills are charged.
class RaceSettlement extends Equatable {
  const RaceSettlement({
    required this.balance,
    this.prize = 0,
    this.bestBonus = 0,
    this.cleanBonus = 0,
    this.traffic = 0,
    this.fine = 0,
    this.hospital = 0,
    this.garage = 0,
  });

  final int balance;
  final int prize;

  /// Bonus for a new best time, and bonus for a race with no bashing.
  final int bestBonus, cleanBonus;

  /// Fines for hitting traffic.
  final int traffic;
  final int fine;
  final int hospital;
  final int garage;

  @override
  List<Object?> get props => [
    balance,
    prize,
    bestBonus,
    cleanBonus,
    traffic,
    fine,
    hospital,
    garage,
  ];
}
