import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:flutter/material.dart';

class ReceiverInfo extends StatelessWidget {
  final LedgerEntity ledger;

  const ReceiverInfo({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 2),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyles.fustatLight.copyWith(
                  fontSize: 10,
                  color: ColorsConstants.backgroundBlack,
                  letterSpacing: -0.4,
                ),
                children: [
                  TextSpan(text: "To, "),
                  TextSpan(
                    text: ledger.friend.userName,
                    style: TextStyles.fustatBold.copyWith(
                      fontSize: 12,
                      color: ColorsConstants.backgroundBlack,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              ledger.trip!.title,
              style: TextStyles.fustatSemiBold.copyWith(
                fontSize: 16,
                color: ColorsConstants.backgroundBlack,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "${ledger.trip!.selectedCurrency}${Methods.formatAmount(ledger.amount, ledger.trip!.selectedCurrency)}",
            style: TextStyles.fustatExtraBold.copyWith(
              fontSize: 20,
              color: ColorsConstants.warningRed, // warningRed
              letterSpacing: -0.4,
            ),
          ),
        ),
      ],
    );
  }
}
