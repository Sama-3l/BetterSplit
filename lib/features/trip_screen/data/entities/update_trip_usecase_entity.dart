// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';

class UpdateTripUsecaseEntity {
  String tripId;
  String? title;
  DateTime? startDate;
  DateTime? endDate;
  String? qrInfo;
  String? icon;
  bool? goingOn;
  String? stats;
  String? selectedCurrency;
  List<UserModel>? users;
  List<PaymentModel>? payments;
  List<LedgerModel>? ledger;
  Map<String, double>? netBalance;

  UpdateTripUsecaseEntity({
    required this.tripId,
    this.title,
    this.startDate,
    this.endDate,
    this.qrInfo,
    this.icon,
    this.goingOn,
    this.stats,
    this.selectedCurrency,
    this.users,
    this.payments,
    this.ledger,
    this.netBalance,
  });
}
