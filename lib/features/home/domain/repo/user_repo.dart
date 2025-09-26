// features/home/domain/repositories/user_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> saveUser(UserEntity user);
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, UserEntity?>> getUserByNumber(String phoneNumber);
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, void>> deleteAllUsers();
}
