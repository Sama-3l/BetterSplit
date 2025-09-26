// lib/features/home/domain/entities/ledger_entity.dart
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';

class LedgerEntity {
  final String id;
  final TripEntity? trip;
  final UserEntity payer;
  final UserEntity friend;
  final double amount;
  final bool completed;

  const LedgerEntity({
    required this.id,
    this.trip,
    required this.payer,
    required this.friend,
    required this.amount,
    this.completed = false,
  });

  LedgerEntity copyWith({
    String? id,
    TripEntity? trip,
    UserEntity? payer,
    UserEntity? friend,
    double? amount,
    bool? completed,
  }) {
    return LedgerEntity(
      id: id ?? this.id,
      trip: trip ?? this.trip,
      payer: payer ?? this.payer,
      friend: friend ?? this.friend,
      amount: amount ?? this.amount,
      completed: completed ?? this.completed,
    );
  }
}
