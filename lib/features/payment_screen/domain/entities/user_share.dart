import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';

class UserShareEntity {
  final PaymentEntity? payment; // optional reference to payment
  final UserEntity user; // the user in this share
  double? amount; // for unequal splits
  double? percentage; // for percentage splits
  bool isIncluded; // for equal split inclusion

  UserShareEntity({
    this.payment,
    required this.user,
    this.amount,
    this.percentage,
    this.isIncluded = true,
  });
}
