part of 'add_trip_cubit.dart';

@immutable
sealed class AddTripState {
  final List<Map<String, dynamic>> users;
  final TripLogo selectedLogo;

  const AddTripState({required this.users, required this.selectedLogo});
}

final class AddTripInitial extends AddTripState {
  const AddTripInitial({required super.users, required super.selectedLogo});
}

final class AddTripUpdate extends AddTripState {
  const AddTripUpdate({required super.users, required super.selectedLogo});
}
