import 'package:bettersplitapp/features/home/data/usecases/delete_trip_usecase.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_all_trips_usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final GetAllTripsUsecase getAllTripsUsecase;
  final DeleteTripUsecase deleteTripUsecase;
  HomeScreenCubit({
    required this.getAllTripsUsecase,
    required this.deleteTripUsecase,
  }) : super(HomeScreenUpdated(trips: [], ledgers: []));

  init(UserEntity currentUser) async {
    final result = await getAllTripsUsecase(currentUser.id);
    result.fold((failure) {}, (trips) {
      state.trips.clear();
      state.trips.addAll(trips);
      state.trips.sort((a, b) => b.startDate.compareTo(a.startDate));
    });
    final ledgers = state.trips.expand((e) => e.ledger).toList();
    state.ledgers.clear();
    state.ledgers.addAll(ledgers);
    emit(HomeScreenUpdated(trips: state.trips, ledgers: state.ledgers));
  }

  deleteTrip(TripEntity trip, int index) async {
    final result = await deleteTripUsecase(trip);
    result.fold((failure) {}, (_) {
      state.trips.removeAt(index);
      emit(HomeScreenUpdated(trips: state.trips, ledgers: state.ledgers));
    });
  }
}
