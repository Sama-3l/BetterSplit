import 'package:bettersplitapp/features/top_bar_widget/screens/make_payment_slider.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The TopBarWidgets in Flutter
class TopBarWidgets extends StatefulWidget {
  final int currentTab;
  final UserEntity user;
  final List<LedgerEntity> debts;
  final List<TripEntity>? trips;
  final double radius;
  final bool tripHeader;

  const TopBarWidgets({
    super.key,
    required this.currentTab,
    this.trips,
    required this.debts,

    required this.user,
    this.radius = 32,
    this.tripHeader = false,
  });

  @override
  State<TopBarWidgets> createState() => _TopBarWidgetsState();
}

class _TopBarWidgetsState extends State<TopBarWidgets> {
  int visibleIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.currentTab == 0) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.radius),
          bottomRight: Radius.circular(widget.radius),
        ),
        child: Container(
          color: ColorsConstants.accentGreen,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorsConstants.surfaceGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.debts.isNotEmpty) ...[
                      Text(
                        "Pending Payments",
                        style: TextStyles.fustatSemiBold.copyWith(
                          fontSize: 16,
                          color: ColorsConstants.backgroundBlack,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 64,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 1),
                          itemCount: widget.debts.length,
                          onPageChanged: (index) {
                            setState(() => visibleIndex = index);
                          },
                          itemBuilder: (context, index) {
                            return MakePaymentSlider(
                              ledger: widget.debts[index],
                              onSwiped: () {},
                            );
                          },
                        ),
                      ),

                      if (widget.debts.length > 1) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.debts.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: index == visibleIndex
                                    ? ColorsConstants.defaultWhite
                                    : ColorsConstants.defaultWhite.withValues(
                                        alpha: 0.4,
                                      ),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ],
                    ] else ...[
                      Text(
                        "Pending Payments",
                        style: TextStyles.fustatSemiBold.copyWith(
                          fontSize: 16,
                          color: ColorsConstants.backgroundBlack,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "No Pending Payments",
                            style: TextStyles.fustatSemiBold.copyWith(
                              fontSize: 16,
                              letterSpacing: -0.8,
                              color: ColorsConstants.backgroundBlack.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Account tab view
    if (widget.currentTab == 2) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Container(
          color: ColorsConstants.accentGreen,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              GestureDetector(
                child: Stack(
                  clipBehavior:
                      Clip.none, // allows the icon to overflow if needed
                  children: [
                    Text(
                      widget.user.userName,
                      style: TextStyles.fustatBold.copyWith(
                        fontSize: 32,
                        color: ColorsConstants.surfaceBlack,
                        letterSpacing: -1.6,
                        // height: 1,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                    Positioned(
                      bottom: 8, // exactly where you want
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: ColorsConstants.surfaceBlack,
                      ),
                    ),
                    Positioned(
                      bottom: -2, // adjust to taste
                      right: -12, // adjust to taste
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsConstants.onSurfaceBlack,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            CupertinoIcons.pencil,
                            color: ColorsConstants.defaultWhite,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsConstants.surfaceGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _infoTab("Name", widget.user.name),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _infoTab("UPI ID", widget.user.upiID),
                    ),
                    _infoTab("Phone Number", "+91-${widget.user.number}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _infoTab(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.fustatExtraBold.copyWith(
            fontSize: 12,
            letterSpacing: -0.8,
          ),
        ),
        Text(
          info,
          style: TextStyles.fustatBold.copyWith(
            fontSize: 10,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
