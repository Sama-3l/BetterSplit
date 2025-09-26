import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';

class PaymentEntity {
  final String id;
  final TripEntity? trip;
  final UserEntity payer;
  final List<UserShareEntity> shares;
  final DateTime date;
  final String title;
  final double amount;
  final bool settled;
  final String splitType; // e.g., "equally"

  const PaymentEntity({
    required this.id,
    this.trip,
    required this.payer,
    required this.shares,
    required this.date,
    required this.title,
    required this.amount,
    required this.settled,
    this.splitType = 'equally',
  });

  PaymentEntity copyWith({
    String? id,
    TripEntity? trip,
    UserEntity? payer,
    List<UserShareEntity>? shares,
    DateTime? date,
    String? title,
    double? amount,
    bool? settled,
    String? splitType,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      payer: payer ?? this.payer,
      shares: shares ?? this.shares,
      date: date ?? this.date,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      settled: settled ?? this.settled,
    );
  }
}
