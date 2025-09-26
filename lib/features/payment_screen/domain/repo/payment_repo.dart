// features/home/domain/repositories/user_repository.dart
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class PaymentRepo {
  Future<Either<Failure, void>> savePayment(PaymentEntity payment);
  Future<Either<Failure, List<PaymentEntity>>> getAllPayments(String tripId);
  Future<Either<Failure, void>> deleteAllPayments();
  Future<Either<Failure, void>> deletePayment(PaymentEntity payment);
}
