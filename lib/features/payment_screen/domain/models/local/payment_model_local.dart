import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/user_share_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:hive/hive.dart';

part 'payment_model_local.g.dart';

@HiveType(typeId: 2)
class PaymentModel extends HiveObject {
  @HiveField(0)
  String id;

  // Top-level relationships stored as IDs
  @HiveField(1)
  String? tripId;
  @HiveField(2)
  UserModel payer;

  // Shares embedded
  @HiveField(3)
  List<UserShareModel> shares;

  @HiveField(4)
  int date; // store as timestamp
  @HiveField(5)
  String title;
  @HiveField(6)
  double amount;
  @HiveField(7)
  bool settled;
  @HiveField(8)
  String splitType;

  PaymentModel({
    required this.id,
    this.tripId,
    required this.payer,
    required this.shares,
    required this.date,
    required this.title,
    required this.amount,
    required this.settled,
    required this.splitType,
  });

  PaymentEntity toEntity({TripEntity? trip}) {
    return PaymentEntity(
      id: id,
      trip: trip,
      payer: payer.toEntity(),
      shares: shares.map((e) => e.toEntity()).toList(),
      date: DateTime.fromMillisecondsSinceEpoch(date),
      title: title,
      amount: amount,
      settled: settled,
      splitType: splitType,
    );
  }

  /// Create Model from Entity
  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      tripId: entity.trip?.id,
      payer: UserModel.fromEntity(entity.payer),
      shares: entity.shares.map((s) => UserShareModel.fromEntity(s)).toList(),
      date: entity.date.millisecondsSinceEpoch,
      title: entity.title,
      amount: entity.amount,
      settled: entity.settled,
      splitType: entity.splitType,
    );
  }

  /// From JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      tripId: json['tripId'],
      payer: UserModel.fromJson(json['payer']),
      shares: (json['shares'] as List<dynamic>)
          .map((s) => UserShareModel.fromJson(s))
          .toList(),
      date: json['date'],
      title: json['title'],
      amount: json['amount'],
      settled: json['settled'],
      splitType: json['splitType'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'payerId': payer.toJson(),
      'shares': shares.map((s) => s.toJson()).toList(),
      'date': date,
      'title': title,
      'amount': amount,
      'settled': settled,
      'splitType': splitType,
    };
  }
}
