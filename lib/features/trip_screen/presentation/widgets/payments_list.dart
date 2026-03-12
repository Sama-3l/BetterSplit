import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/presentation/widgets/trips_header.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar_widgets.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/TripScreen/trip_screen_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/screens/add_trip_screen.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/payment_tile.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/the_ledger.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/trip_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsList extends StatelessWidget {
  final TripEntity trip;
  final UserEntity currUser;
  final Function() onAddPayment;

  const PaymentsList({
    super.key,
    required this.trip,
    required this.currUser,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TripScreenCubit>();
    return trip.payments.isEmpty
        ? Column(
            children: [
              TopBarWidgets(
                currentTab: 0,
                debts: [],
                user: currUser,
                radius: 0,
                tripHeader: false,
                onSwiped: (ledger) {},
              ),
              TripHeader(
                onEditTrip: () async {
                  final result = await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => AddTripBottomSheet(
                      currentUser: currUser,
                      editTrip: true,
                      trip: trip,
                    ),
                  );
                  if (result != null) {
                    print((result as TripEntity).title);
                    cubit.updateTrip(result);
                  }
                },
                onMergeFinalQR: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TripsHeaderWidget(
                  title: "Payments",
                  onAdd: () => onAddPayment(),
                  onSearch: (value) {},
                ),
              ),
              Spacer(),
              Center(
                child: Text(
                  "No Payments Yet",
                  style: TextStyles.fustatBold.copyWith(
                    color: ColorsConstants.defaultWhite.withValues(alpha: 0.5),
                    fontSize: 16,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              Spacer(),
            ],
          )
        : Column(
            children: [
              TripHeader(
                onEditTrip: () async {
                  final result = await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => AddTripBottomSheet(
                      currentUser: currUser,
                      editTrip: true,
                      trip: trip,
                    ),
                  );
                  if (result != null) {
                    cubit.updateTrip(result);
                  }
                },
                onMergeFinalQR: () {},
              ),
              Expanded(
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: TopBarWidgets(
                        currentTab: 0,
                        debts: trip.ledger
                            .where((e) => e.payer.id == currUser.id)
                            .toList(),
                        user: currUser,
                        radius: 32,
                        tripHeader: false,
                        onSwiped: (ledger) {},
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.only(top: 24.0),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: TripsHeaderDelegate(
                          title: 'Ledger',
                          onSearch: (String search) {},
                          options: [
                            CircularButton(
                              icon: CupertinoIcons.qrcode,
                              color: ColorsConstants.defaultWhite,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: TheLedger(trip: trip, currUser: currUser),
                      ),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: TripsHeaderDelegate(
                        options: [
                          CircularButton(
                            icon: CupertinoIcons.search,
                            color: ColorsConstants.defaultWhite,
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          CircularButton(
                            icon: CupertinoIcons.add,
                            color: ColorsConstants.defaultWhite,
                            onTap: () => onAddPayment(),
                          ),
                        ],
                        title: 'Payments',
                        onSearch: (String search) {},
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      sliver: SliverList.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        itemCount: trip.payments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: ValueKey(
                              trip
                                  .payments[trip.payments.length - 1 - index]
                                  .id,
                            ), // unique key per payment
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              for (var s
                                  in trip
                                      .payments[trip.payments.length -
                                          1 -
                                          index]
                                      .shares) {
                                s.isIncluded =
                                    s.isIncluded ||
                                    (s.amount != null && s.amount != 0);
                              }
                              final newTrip = Methods.addPayment(
                                title: trip
                                    .payments[trip.payments.length - 1 - index]
                                    .title,
                                trip: trip,
                                paidByUser: trip
                                    .payments[trip.payments.length - 1 - index]
                                    .payer,
                                amount: trip
                                    .payments[trip.payments.length - 1 - index]
                                    .amount,
                                userShares: trip
                                    .payments[trip.payments.length - 1 - index]
                                    .shares,
                                delete: true,
                                currPayment: trip
                                    .payments[trip.payments.length - 1 - index],
                              );
                              cubit.updateTrip(newTrip);
                            },
                            background: Container(
                              color: ColorsConstants.warningRed,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: ColorsConstants.backgroundBlack,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // for (var s in trip.payments[index].shares) {
                                  //   s.isIncluded =
                                  //       s.isIncluded ||
                                  //       (s.amount != null && s.amount != 0);
                                  // }
                                  // final newTrip = Methods.addPayment(
                                  //   title: trip.payments[index].title,
                                  //   trip: trip,
                                  //   paidByUser: trip.payments[index].payer,
                                  //   amount: trip.payments[index].amount,
                                  //   userShares: trip.payments[index].shares,
                                  //   delete: true,
                                  //   currPayment: trip.payments[index],
                                  // );
                                  // cubit.updateTrip(newTrip);
                                },
                                child: PaymentTile(
                                  trip: trip,
                                  currUser: currUser,
                                  payment:
                                      trip.payments[trip.payments.length -
                                          1 -
                                          index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
