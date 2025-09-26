part of 'main_app_cubit.dart';

@immutable
sealed class MainAppState {
  final UserEntity? user;
  final List<TripEntity> trips;
  final int tab;

  const MainAppState({this.user, required this.trips, this.tab = 0});
}

final class MainAppInitial extends MainAppState {
  const MainAppInitial({super.user, required super.trips, super.tab});
}

final class MainAppLoading extends MainAppState {
  const MainAppLoading({super.user, required super.trips, super.tab});
}

final class MainAppUpdate extends MainAppState {
  const MainAppUpdate({super.user, required super.trips, super.tab});
}

final class ChangeTabState extends MainAppState {
  const ChangeTabState({super.user, required super.trips, required super.tab});
}
