// features/home/domain/usecases/save_user_usecase.dart
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

class DeleteAllUsersUsecase extends UseCase<void, NoParams> {
  final UserRepository _repository;

  DeleteAllUsersUsecase({required UserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(NoParams noparams) {
    return _repository.deleteAllUsers();
  }
}
