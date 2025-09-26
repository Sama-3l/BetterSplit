part of 'trip_screen_cubit.dart';

@immutable
sealed class TripScreenState {
  final TripEntity? trip;

  const TripScreenState({this.trip});
}

final class TripScreenInitial extends TripScreenState {
  const TripScreenInitial({super.trip});
}

final class UpdateTrip extends TripScreenState {
  const UpdateTrip({super.trip});
}
