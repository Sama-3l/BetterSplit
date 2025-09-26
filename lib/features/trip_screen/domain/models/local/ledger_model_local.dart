// lib/features/home/data/models/ledger_model.dart
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:hive/hive.dart';

part 'ledger_model_local.g.dart';

@HiveType(typeId: 5)
class LedgerModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? tripId;

  @HiveField(2)
  UserModel payer;

  @HiveField(3)
  UserModel friend;

  @HiveField(4)
  double amount;

  @HiveField(5)
  bool completed;

  LedgerModel({
    required this.id,
    this.tripId,
    required this.payer,
    required this.friend,
    required this.amount,
    this.completed = false,
  });

  /// convert to domain entity (need to pass fully loaded objects)
  LedgerEntity toEntity({TripEntity? trip}) {
    return LedgerEntity(
      id: id,
      trip: trip,
      payer: payer.toEntity(),
      friend: friend.toEntity(),
      amount: amount,
      completed: completed,
    );
  }

  factory LedgerModel.fromEntity(LedgerEntity entity) {
    return LedgerModel(
      id: entity.id,
      tripId: entity.trip?.id,
      payer: UserModel.fromEntity(entity.payer),
      friend: UserModel.fromEntity(entity.friend),
      amount: entity.amount,
      completed: entity.completed,
    );
  }

  factory LedgerModel.fromJson(Map<String, dynamic> json) {
    return LedgerModel(
      id: json['id'],
      tripId: json['tripId'],
      payer: UserModel.fromJson(json['payer']),
      friend: UserModel.fromJson(json['friend']),
      amount: (json['amount'] as num).toDouble(),
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'payer': payer.toJson(),
      'friend': friend.toJson(),
      'amount': amount,
      'completed': completed,
    };
  }
}
