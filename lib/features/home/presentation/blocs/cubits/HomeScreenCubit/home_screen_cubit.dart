import 'package:bettersplitapp/features/home/data/usecases/delete_trip_usecase.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_all_trips_usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/update_trip_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final GetAllTripsUsecase getAllTripsUsecase;
  final DeleteTripUsecase deleteTripUsecase;
  final UpdateTripUsecase updateTripUsecase;
  HomeScreenCubit({
    required this.getAllTripsUsecase,
    required this.deleteTripUsecase,
    required this.updateTripUsecase,
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

  updateTrip(TripEntity trip) async {
    final entity = UpdateTripUsecaseEntity(
      tripId: trip.id,
      selectedCurrency: trip.selectedCurrency,
      netBalance: trip.netBalance,
      ledger: trip.ledger.map((e) => LedgerModel.fromEntity(e)).toList(),
      payments: trip.payments.map((e) => PaymentModel.fromEntity(e)).toList(),
    );
    await updateTripUsecase(entity);
  }

  updateHomeScreen(UserEntity currentUser) async {
    final result = await getAllTripsUsecase(currentUser.id);
    result.fold((failure) {}, (trips) {
      final ledgers = trips.expand((e) => e.ledger).toList();
      emit(HomeScreenUpdated(trips: trips, ledgers: ledgers));
    });
  }
}
