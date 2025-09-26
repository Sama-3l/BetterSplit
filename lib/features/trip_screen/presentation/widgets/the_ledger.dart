import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';

class TheLedger extends StatelessWidget {
  final TripEntity trip;
  final UserEntity currUser;

  const TheLedger({super.key, required this.trip, required this.currUser});

  @override
  Widget build(BuildContext context) {
    final ledgerList = trip.ledger;
    int index = 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsConstants.surfaceBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: ledgerList.map((ledger) {
          final isPayer = ledger.payer.id == currUser.id;
          final isFriend = ledger.friend.id == currUser.id;

          final textColor = isPayer
              ? ColorsConstants.warningRed
              : isFriend
              ? ColorsConstants.accentGreen
              : ColorsConstants.defaultWhite;
          index++;
          return Padding(
            padding: EdgeInsets.only(
              top: index == 1 ? 0 : 6.0,
              bottom: index == ledgerList.length ? 0 : 6,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    isPayer ? 'You' : ledger.payer.userName,
                    style: TextStyles.fustatMedium.copyWith(
                      letterSpacing: -0.5,
                      fontSize: 14,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(
                  width: 80,
                  child: Stack(
                    alignment:
                        Alignment.centerRight, // place icon at center-right
                    children: [
                      // line behind
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 1,
                            color: textColor,
                            margin: const EdgeInsets.only(
                              right: 7,
                            ), // leave room for chevron width
                          ),
                        ),
                      ),
                      // chevron exactly on the line
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    isFriend ? 'You' : ledger.friend.userName,
                    style: TextStyles.fustatMedium.copyWith(
                      letterSpacing: -0.5,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  "${trip.selectedCurrency}${Methods.formatAmount(ledger.amount, trip.selectedCurrency)}",
                  style: TextStyles.fustatExtraBold.copyWith(
                    letterSpacing: -0.5,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
