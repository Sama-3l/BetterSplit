import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserByNumberUsecase extends UseCase<UserEntity?, String> {
  final UserRepository _userRepository;

  GetUserByNumberUsecase(UserRepository userRepo) : _userRepository = userRepo;

  @override
  Future<Either<Failure, UserEntity?>> call(String phoneNumber) {
    return _userRepository.getUserByNumber(phoneNumber);
  }
}
