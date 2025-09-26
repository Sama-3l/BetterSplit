import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:hive/hive.dart';

part 'user_share_model_local.g.dart';

@HiveType(typeId: 3)
class UserShareModel {
  @HiveField(0)
  UserModel user;
  @HiveField(1)
  double? amount;
  @HiveField(2)
  double? percentage;

  UserShareModel({required this.user, this.amount, this.percentage});

  UserShareEntity toEntity() {
    return UserShareEntity(
      user: user.toEntity(),
      amount: amount,
      percentage: percentage,
    );
  }

  factory UserShareModel.fromEntity(UserShareEntity entity) {
    return UserShareModel(
      user: UserModel.fromEntity(entity.user),
      amount: entity.amount,
      percentage: entity.percentage,
    );
  }

  factory UserShareModel.fromJson(Map<String, dynamic> json) {
    return UserShareModel(
      user: json['user'],
      amount: json['amount'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user, 'amount': amount, 'percentage': percentage};
  }
}
