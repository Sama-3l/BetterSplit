import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentTile extends StatelessWidget {
  final TripEntity trip;
  final PaymentEntity payment;
  final UserEntity currUser;

  const PaymentTile({
    super.key,
    required this.trip,
    required this.payment,
    required this.currUser,
  });

  @override
  Widget build(BuildContext context) {
    final paidByPerson = payment.payer.id == currUser.id
        ? "You"
        : payment.payer.userName;

    final totalAmount = payment.amount;

    // 🟢 Case resolution
    final myShare =
        payment.shares
            .firstWhere(
              (s) => s.user.id == currUser.id,
              orElse: () => UserShareEntity(user: currUser, amount: 0),
            )
            .amount ??
        0;

    late Color amountColor;
    late String displayAmount;
    late String subtitleText;
    late Color subtitleColor;

    if (currUser.id == payment.payer.id) {
      // user is payer: show lent = total - their own share
      final lentAmount = totalAmount - myShare;
      amountColor = ColorsConstants.accentGreen;
      displayAmount = Methods.formatAmount(
        lentAmount,
        trip.selectedCurrency,
      ); // e.g. $
      subtitleText = "You lent";
      subtitleColor = ColorsConstants.accentGreen.withValues(alpha: 0.8);
    } else if (myShare > 0) {
      // user owes
      amountColor = ColorsConstants.warningRed;
      displayAmount = Methods.formatAmount(myShare, trip.selectedCurrency);
      subtitleText = "You owe ${payment.payer.userName}";
      subtitleColor = ColorsConstants.warningRed.withValues(alpha: 0.8);
    } else {
      // not involved
      amountColor = ColorsConstants.defaultWhite;
      displayAmount = "not";
      subtitleText = "involved";
      subtitleColor = ColorsConstants.defaultWhite.withValues(alpha: 0.8);
    }

    final paidAmount = Methods.formatAmount(myShare, trip.selectedCurrency);

    final date = payment.date;
    final month = DateFormat.MMM().format(date).toUpperCase(); // e.g. AUG
    final day = DateFormat('dd').format(date);

    return Container(
      decoration: BoxDecoration(
        color: ColorsConstants.surfaceBlack, // surfaceBlack
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorsConstants.onSurfaceBlack,
              borderRadius: BorderRadius.circular(32),
            ),
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Text(
                  month,
                  style: TextStyles.fustatSemiBold.copyWith(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
                Text(
                  day,
                  style: TextStyles.fustatSemiBold.copyWith(
                    fontSize: 16,
                    letterSpacing: 2,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 16,
                    letterSpacing: -0.8,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
                Text(
                  "$paidByPerson paid ${trip.selectedCurrency}$paidAmount",
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 10,
                    letterSpacing: -0.5,
                    color: ColorsConstants.defaultWhite.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${trip.selectedCurrency}$displayAmount",
                style: TextStyles.fustatExtraBold.copyWith(
                  fontSize: 24,
                  letterSpacing: -1.6,
                  color: amountColor,
                ),
              ),
              Text(
                subtitleText,
                style: TextStyles.fustatExtraBold.copyWith(
                  fontSize: 10,
                  letterSpacing: -0.5,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
