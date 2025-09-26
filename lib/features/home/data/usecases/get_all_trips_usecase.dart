import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllTripsUsecase extends UseCase<List<TripEntity>, String> {
  final TripRepository _tripRepository;

  GetAllTripsUsecase(TripRepository tripRepository)
    : _tripRepository = tripRepository;

  @override
  Future<Either<Failure, List<TripEntity>>> call(String userId) {
    return _tripRepository.getAllTrips(userId);
  }
}
