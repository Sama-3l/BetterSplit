import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';
import 'package:hive/hive.dart';

part 'trip_model_local.g.dart';

@HiveType(typeId: 6)
class TripModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  @HiveField(4)
  String qrInfo;

  @HiveField(5)
  String icon;

  @HiveField(6)
  bool goingOn;

  @HiveField(7)
  String stats;

  @HiveField(8)
  String selectedCurrency;

  @HiveField(9)
  List<UserModel> users; // references UserModels

  @HiveField(10)
  List<PaymentModel> payments; // references PaymentModels

  @HiveField(11)
  List<LedgerModel> ledger; // references LedgerModels

  @HiveField(12)
  Map<String, double> netBalance;

  TripModel({
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

  /// Convert model → entity (needs loaded objects)
  TripEntity toEntity() {
    final trip = TripEntity(
      id: id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      qrInfo: qrInfo,
      icon: icon,
      goingOn: goingOn,
      stats: stats,
      selectedCurrency: selectedCurrency,
      users: users.map((e) => e.toEntity()).toList(),
      payments: payments.map((e) => e.toEntity()).toList(),
      netBalance: netBalance,
    );
    return trip.copyWith(
      ledger: ledger.map((e) => e.toEntity(trip: trip)).toList(),
    );
  }

  factory TripModel.fromEntity(TripEntity entity) {
    return TripModel(
      id: entity.id,
      title: entity.title,
      startDate: entity.startDate,
      endDate: entity.endDate,
      qrInfo: entity.qrInfo,
      icon: entity.icon,
      goingOn: entity.goingOn,
      stats: entity.stats,
      selectedCurrency: entity.selectedCurrency,
      users: entity.users.map((u) => UserModel.fromEntity(u)).toList(),
      payments: entity.payments.map((p) => PaymentModel.fromEntity(p)).toList(),
      ledger: entity.ledger.map((l) => LedgerModel.fromEntity(l)).toList(),
      netBalance: entity.netBalance,
    );
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      title: json['title'],
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      qrInfo: json['qrInfo'] ?? '',
      icon: json['icon'] ?? 'car.fill',
      goingOn: json['goingOn'] ?? false,
      stats: json['stats'] ?? '',
      selectedCurrency: json['selectedCurrency'] ?? '₹',
      users: List<UserModel>.from(json['users'] ?? []),
      payments: List<PaymentModel>.from(json['payments'] ?? []),
      ledger: List<LedgerModel>.from(json['ledgers'] ?? []),
      netBalance: Map<String, double>.from(json['netBalance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'qrInfo': qrInfo,
      'icon': icon,
      'goingOn': goingOn,
      'stats': stats,
      'selectedCurrency': selectedCurrency,
      'users': users,
      'payments': payments,
      'ledger': ledger,
      'netBalance': netBalance,
    };
  }
}
