import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/features/home/presentation/widgets/trip_tile.dart';
import 'package:bettersplitapp/features/home/presentation/widgets/trips_header.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar_widgets.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/presentation/blocs/cubits/HomeScreenCubit/home_screen_cubit.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/screens/add_trip_screen.dart';
import 'package:bettersplitapp/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeScreenCubit>()..init(user),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          final cubit = context.read<HomeScreenCubit>();
          // Hive.deleteFromDisk();
          return Scaffold(
            backgroundColor: ColorsConstants.backgroundBlack,
            body: Column(
              children: [
                TopBar(
                  title: user.userName,
                  subtitle: "Hello!",
                  onTap: () {
                    // deleteCurrentUser(modelContext)
                    print(user.id);
                  },
                ),
                if (state.trips.isEmpty) ...[
                  TopBarWidgets(currentTab: 0, debts: [], user: user),
                  const SizedBox(height: 16),
                  TripsHeaderWidget(
                    onAdd: () async {
                      final result = await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) =>
                            AddTripBottomSheet(currentUser: user),
                      );
                      if (result) {
                        cubit.init(user);
                      }
                    },
                    title: 'Trips',
                    onSearch: (String search) {},
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "No Payments Yet",
                        style: TextStyles.fustatBold.copyWith(
                          color: ColorsConstants.defaultWhite.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 16,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                ],
                if (state.trips.isNotEmpty)
                  Expanded(
                    child: CustomScrollView(
                      physics: ClampingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: TopBarWidgets(
                            currentTab: 0,
                            debts: state.ledgers
                                .where((e) => e.payer.id == user.id)
                                .toList(),
                            user: user,
                          ),
                        ),

                        SliverPadding(
                          padding: EdgeInsets.only(top: 16),
                          sliver: SliverPersistentHeader(
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
                                  onTap: () async {
                                    final result = await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) =>
                                          AddTripBottomSheet(currentUser: user),
                                    );

                                    if (result != null && result) {
                                      cubit.init(user);
                                    }
                                  },
                                ),
                              ],
                              title: 'Trips',
                              onSearch: (String search) {},
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: EdgeInsets.only(top: 16),
                          sliver: SliverList.separated(
                            separatorBuilder: (context, index) => Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  color: ColorsConstants.defaultWhite
                                      .withValues(alpha: 0.1),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                            itemCount: state.trips.length,
                            itemBuilder: (BuildContext context, int index) {
                              final trip = state.trips[index];
                              print(trip.netBalance);
                              return Dismissible(
                                key: ValueKey(trip.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) =>
                                    cubit.deleteTrip(trip, index),
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
                                    horizontal: 16.0,
                                  ),
                                  child: TripTile(
                                    trip: trip,
                                    currentUser: user,
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
            ),
          );
        },
      ),
    );
  }
}
