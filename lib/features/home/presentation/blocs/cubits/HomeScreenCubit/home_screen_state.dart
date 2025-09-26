part of 'home_screen_cubit.dart';

@immutable
sealed class HomeScreenState {
  final List<TripEntity> trips;
  final List<LedgerEntity> ledgers;

  const HomeScreenState({required this.trips, required this.ledgers});
}

final class HomeScreenUpdated extends HomeScreenState {
  const HomeScreenUpdated({required super.trips, required super.ledgers});
}
