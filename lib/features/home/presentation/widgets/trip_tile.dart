import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/routes/app_route_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TripTile extends StatelessWidget {
  final TripEntity trip;
  final UserEntity currentUser;

  const TripTile({super.key, required this.trip, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // fetch from your trip.netBalance map
    final double amount = trip.netBalance[currentUser.number] ?? 0;
    final String selectedCurrency = trip.selectedCurrency;

    return InkWell(
      onTap: () => GoRouter.of(context).pushNamed(
        Routes.tripScreen,
        extra: {'trip': trip, 'currUser': currentUser},
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ColorsConstants.onSurfaceBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    TripLogo.fromName(trip.icon).icon,
                    colorFilter: ColorFilter.mode(
                      ColorsConstants.accentGreen,
                      BlendMode.srcIn,
                    ),
                    height: 16,
                    width: 16,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Title + Dates
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: TextStyles.fustatExtraBold.copyWith(
                        fontSize: 16,
                        letterSpacing: -0.8,
                        color: ColorsConstants.defaultWhite,
                      ),
                    ),
                    Text(
                      Methods.formatDateRange(
                        trip.startDate,
                        trip.endDate,
                        trip.goingOn,
                      ),
                      style: TextStyles.fustatRegular.copyWith(
                        fontSize: 12,
                        letterSpacing: -0.6,
                        color: ColorsConstants.defaultWhite.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount & status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (amount == 0) ...[
                    Text(
                      "$selectedCurrency 0",
                      style: TextStyles.fustatExtraBold.copyWith(
                        fontSize: 16,
                        letterSpacing: -0.8,
                        color: ColorsConstants.defaultWhite,
                      ),
                    ),
                    Text(
                      "No Transactions Yet",
                      style: TextStyles.fustatRegular.copyWith(
                        fontSize: 10,
                        letterSpacing: -0.2,
                        color: ColorsConstants.defaultWhite.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "$selectedCurrency${Methods.formatAmount(amount.abs(), selectedCurrency)}",
                      style: TextStyles.fustatExtraBold.copyWith(
                        fontSize: 16,
                        letterSpacing: -0.8,
                        color: amount < 0
                            ? ColorsConstants.warningRed
                            : ColorsConstants.accentGreen,
                      ),
                    ),
                    Text(
                      amount < 0 ? "Total you owe" : "Total you’re owed",
                      style: TextStyles.fustatRegular.copyWith(
                        fontSize: 10,
                        letterSpacing: -0.2,
                        color:
                            (amount < 0
                                    ? ColorsConstants.warningRed
                                    : ColorsConstants.accentGreen)
                                .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
