// Package imports:
import 'package:equatable/equatable.dart';

/// How a race ended for the player's wallet.
enum RaceEnd { finished, busted, crashed }

/// What a race paid or cost, in shillings, and the wallet balance after it.
class RaceSettlement extends Equatable {
  const RaceSettlement({
    required this.balance,
    this.prize = 0,
    this.fine = 0,
    this.hospital = 0,
    this.garage = 0,
  });

  final int balance;
  final int prize;
  final int fine;
  final int hospital;
  final int garage;

  @override
  List<Object?> get props => [balance, prize, fine, hospital, garage];
}
