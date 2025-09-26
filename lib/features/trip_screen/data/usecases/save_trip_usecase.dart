import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

class SaveTripUseCase extends UseCase<void, TripEntity> {
  final TripRepository _repository;

  SaveTripUseCase({required TripRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(TripEntity entity) {
    return _repository.saveTrip(entity);
  }
}
