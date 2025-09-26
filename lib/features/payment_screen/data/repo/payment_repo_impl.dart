import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/features/payment_screen/data/datasources/payment_local_datasource.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/repo/payment_repo.dart';
import 'package:dartz/dartz.dart';

class PaymentRepoImpl extends PaymentRepo {
  final PaymentLocalDatasource _datasource;

  PaymentRepoImpl(PaymentLocalDatasource datasource) : _datasource = datasource;

  @override
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments(String id) async {
    try {
      final payments = await _datasource.getCurrentTripPayments(id);
      return Right(payments.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> savePayment(PaymentEntity payment) async {
    try {
      await _datasource.savePayment(PaymentModel.fromEntity(payment));
      return Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllPayments() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deletePayment(PaymentEntity payment) async {
    try {
      await _datasource.deletePayment(PaymentModel.fromEntity(payment));
      return Right(null);
    } catch (e) {
      return Left(LocalStorageFailure());
    }
  }
}
