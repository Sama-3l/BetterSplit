// features/home/domain/usecases/save_user_usecase.dart
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

class GetAllUsersUsecase extends UseCase<List<UserEntity>, NoParams> {
  final UserRepository _repository;

  GetAllUsersUsecase({required UserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams noparams) {
    return _repository.getAllUsers();
  }
}
