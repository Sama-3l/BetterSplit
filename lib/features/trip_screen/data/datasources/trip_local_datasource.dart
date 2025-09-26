import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/trip_model_local.dart';
import 'package:hive/hive.dart';

abstract class TripLocalDataSource {
  Future<void> saveTrip(TripModel trip);
  Future<void> deleteTrip(TripModel trip);
  Future<TripModel?> getTripById(String id);
  Future<void> updateTrip(UpdateTripUsecaseEntity entity);
  Future<List<TripModel>> getAllTrips();
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  static const _tripBoxName = 'tripBox';

  @override
  Future<void> saveTrip(TripModel trip) async {
    final box = await Hive.openBox<TripModel>(_tripBoxName);
    await box.put(trip.id, trip);
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    final box = await Hive.openBox<TripModel>(_tripBoxName);
    try {
      return box.values.toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> deleteTrip(TripModel trip) async {
    final box = await Hive.openBox<TripModel>(_tripBoxName);
    try {
      box.delete(trip.id);
    } catch (_) {}
  }

  @override
  Future<void> updateTrip(UpdateTripUsecaseEntity entity) async {
    final tripBox = await Hive.openBox<TripModel>(_tripBoxName);
    final trip = tripBox.values.firstWhere(
      (t) => t.id == entity.tripId,
      orElse: () => throw Exception('Trip not found'),
    );

    if (entity.title != null) trip.title = entity.title!;
    if (entity.startDate != null) trip.startDate = entity.startDate!;
    if (entity.endDate != null) trip.endDate = entity.endDate!;
    if (entity.qrInfo != null) trip.qrInfo = entity.qrInfo!;
    if (entity.icon != null) trip.icon = entity.icon!;
    if (entity.goingOn != null) trip.goingOn = entity.goingOn!;
    if (entity.stats != null) trip.stats = entity.stats!;
    if (entity.selectedCurrency != null) {
      trip.selectedCurrency = entity.selectedCurrency!;
    }
    if (entity.users != null) trip.users = entity.users!;
    if (entity.payments != null) trip.payments = entity.payments!;
    if (entity.ledger != null) trip.ledger = entity.ledger!;
    if (entity.netBalance != null) trip.netBalance = entity.netBalance!;

    await trip.save();
  }

  @override
  Future<TripModel?> getTripById(String id) async {
    final box = await Hive.openBox<TripModel>(_tripBoxName);
    try {
      return box.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
