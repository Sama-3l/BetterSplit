import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateTripUsecase extends UseCase<void, UpdateTripUsecaseEntity> {
  final TripRepository _tripRepository;

  UpdateTripUsecase(this._tripRepository);

  @override
  Future<Either<Failure, void>> call(UpdateTripUsecaseEntity entity) {
    return _tripRepository.updateTrip(entity);
  }
}
