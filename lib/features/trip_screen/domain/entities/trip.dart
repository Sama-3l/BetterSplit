// lib/features/home/domain/entities/trip_entity.dart
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';

class TripEntity {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String qrInfo;
  final String icon;
  final bool goingOn;
  final String stats;
  final String selectedCurrency;

  final List<UserEntity> users;
  final List<PaymentEntity> payments;
  final List<LedgerEntity> ledger;
  final Map<String, double> netBalance;

  const TripEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.qrInfo = '',
    this.icon = 'car.fill',
    this.goingOn = false,
    this.stats = '',
    this.selectedCurrency = '₹',
    this.users = const [],
    this.payments = const [],
    this.ledger = const [],
    this.netBalance = const {},
  });

  TripEntity copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? qrInfo,
    String? icon,
    bool? goingOn,
    String? stats,
    String? selectedCurrency,
    List<UserEntity>? users,
    List<PaymentEntity>? payments,
    List<LedgerEntity>? ledger,
    Map<String, double>? netBalance,
  }) {
    return TripEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      qrInfo: qrInfo ?? this.qrInfo,
      icon: icon ?? this.icon,
      goingOn: goingOn ?? this.goingOn,
      stats: stats ?? this.stats,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      users: users ?? this.users,
      payments: payments ?? this.payments,
      ledger: ledger ?? this.ledger,
      netBalance: netBalance ?? this.netBalance,
    );
  }
}
