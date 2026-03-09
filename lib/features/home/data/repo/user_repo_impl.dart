// features/home/data/repositories/user_repository_impl.dart
import 'package:bettersplitapp/features/home/data/datasource/user_local_datasource.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveUser(UserEntity entity) async {
    try {
      final userModel = UserModel.fromEntity(entity);
      await localDataSource.saveUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity entity) async {
    try {
      final userModel = UserModel.fromEntity(entity);
      await localDataSource.saveUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCurrentUser();
      if (userModel == null) return const Right(null);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await localDataSource.getAllUsers();
      final userEntities = users.map((e) => e.toEntity()).toList();
      return Right(userEntities);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllUsers() async {
    try {
      await localDataSource.deleteAllUsers();
      return Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUserByNumber(
    String phoneNumber,
  ) async {
    try {
      final user = await localDataSource.getUserByNumber(phoneNumber);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }
}
