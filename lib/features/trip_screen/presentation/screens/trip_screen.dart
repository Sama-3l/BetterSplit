import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/blocs/cubits/AddPaymentCubit/add_payment_cubit.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/screens/add_payment_screen.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/TripScreen/trip_screen_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/horizontal_users_list.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/payments_list.dart';
import 'package:bettersplitapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripScreen extends StatefulWidget {
  final TripEntity trip;
  final UserEntity currUser;

  const TripScreen({super.key, required this.trip, required this.currUser});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  bool addPayment = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TripScreenCubit>()..initialize(widget.trip),
      child: BlocBuilder<TripScreenCubit, TripScreenState>(
        builder: (context, state) {
          print(state.trip!.netBalance);
          final cubit = context.read<TripScreenCubit>();
          if (state.trip == null) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsConstants.accentGreen,
              ),
            );
          }
          return Scaffold(
            backgroundColor: ColorsConstants.backgroundBlack,
            body: Column(
              children: [
                TopBar(title: "", onTap: () {}, backButton: true, size: 40),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: ColorsConstants.accentGreen,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Trip title and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.trip!.title,
                              style: TextStyles.fustatBold.copyWith(
                                fontSize: 24,
                                letterSpacing: -1.6,
                                color: ColorsConstants.surfaceBlack,
                              ),
                            ),
                            Text(
                              Methods.formatDateRange(
                                state.trip!.startDate,
                                state.trip!.endDate,
                                state.trip!.goingOn,
                              ),
                              style: TextStyles.fustatSemiBold.copyWith(
                                fontSize: 12,
                                letterSpacing: -0.5,
                                color: ColorsConstants.surfaceBlack,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Trip Participants',
                            style: TextStyles.fustatBold.copyWith(
                              fontSize: 12,
                              letterSpacing: -0.5,
                              color: ColorsConstants.surfaceBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          HorizontalFriendsList(
                            initials: Methods.getInitialsList(
                              state.trip!.users,
                            ),
                            ltr: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: PaymentsList(
                    trip: state.trip!,
                    currUser: widget.currUser,
                    onAddPayment: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => BlocProvider(
                          create: (context) => AddPaymentCubit()
                            ..initialize(
                              widget.trip.selectedCurrency,
                              widget.currUser,
                              widget.trip.users.map((user) {
                                return UserShareEntity(
                                  user: user,
                                  amount: null,
                                  percentage: null,
                                  isIncluded: false,
                                );
                              }).toList(),
                            ),
                          child: AddPaymentBottomSheet(
                            currUser: widget.currUser,
                            trip: state.trip!,
                          ),
                        ),
                      );
                      print((result as TripEntity?)!.netBalance);
                      if (result != null) {
                        cubit.updateTrip((result as TripEntity?)!);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
