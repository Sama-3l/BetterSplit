// features/home/domain/usecases/save_user_usecase.dart
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

class SaveUserUseCase extends UseCase<void, UserEntity> {
  final UserRepository _repository;

  SaveUserUseCase({required UserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(UserEntity entity) {
    return _repository.saveUser(entity);
  }
}
