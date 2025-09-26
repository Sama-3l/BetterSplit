import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:dartz/dartz.dart';

abstract class TripRepository {
  Future<Either<Failure, void>> saveTrip(TripEntity trip);
  Future<Either<Failure, List<TripEntity>>> getAllTrips(String userId);
  Future<Either<Failure, TripEntity?>> getTripById(String userId);
  Future<Either<Failure, void>> deleteTrip(TripEntity trip);
  Future<Either<Failure, void>> updateTrip(UpdateTripUsecaseEntity updateTrip);
}
