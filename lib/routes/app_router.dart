import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/main_app/presentation/screens/main_app.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/screens/trip_screen.dart';
import 'package:bettersplitapp/routes/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: Routes.homeScreen,
        path: Routes.homeScreen,
        pageBuilder: (context, state) => MaterialPage(child: ContentView()),
      ),
      GoRoute(
        name: Routes.tripScreen,
        path: Routes.tripScreen, // e.g. '/trip'
        pageBuilder: (context, state) {
          // retrieve trip + currUser from state.extra
          final extra = state.extra as Map<String, dynamic>;
          final trip = extra['trip'] as TripEntity;
          final currUser = extra['currUser'] as UserEntity;

          return MaterialPage(
            key: state.pageKey,
            child: TripScreen(trip: trip, currUser: currUser),
          );
        },
      ),
    ],
  );
}
