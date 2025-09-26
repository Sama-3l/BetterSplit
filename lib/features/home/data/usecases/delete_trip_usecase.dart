import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteTripUsecase extends UseCase<void, TripEntity> {
  final TripRepository _tripRepository;

  DeleteTripUsecase(TripRepository tripRepository)
    : _tripRepository = tripRepository;

  @override
  Future<Either<Failure, void>> call(TripEntity entity) {
    return _tripRepository.deleteTrip(entity);
  }
}
