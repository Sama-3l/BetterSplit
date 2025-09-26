import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/features/trip_screen/data/datasources/trip_local_datasource.dart';
import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/trip_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:dartz/dartz.dart';

class TripRepoImpl extends TripRepository {
  final TripLocalDataSource localDataSource;

  TripRepoImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<TripEntity>>> getAllTrips(String userId) async {
    try {
      final trips = await localDataSource.getAllTrips();
      final tripEntities = trips.map((e) => e.toEntity()).toList();
      return Right(tripEntities);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTrip(TripEntity trip) async {
    try {
      final tripModel = TripModel.fromEntity(trip);
      await localDataSource.saveTrip(tripModel);
      return const Right(null);
    } catch (e) {
      return const Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrip(TripEntity trip) async {
    try {
      final tripModel = TripModel.fromEntity(trip);
      await localDataSource.deleteTrip(tripModel);
      return const Right(null);
    } catch (e) {
      return const Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTrip(
    UpdateTripUsecaseEntity updateTrip,
  ) async {
    try {
      await localDataSource.updateTrip(updateTrip);
      return const Right(null);
    } catch (e) {
      return const Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, TripEntity?>> getTripById(String userId) async {
    try {
      await localDataSource.getTripById(userId);
      return const Right(null);
    } catch (e) {
      return const Left(LocalStorageFailure());
    }
  }
}
