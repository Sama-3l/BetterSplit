import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/repo/payment_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllPaymentsUsecase extends UseCase<List<PaymentEntity>, String> {
  final PaymentRepo _paymentRepo;

  GetAllPaymentsUsecase(PaymentRepo paymentRepo) : _paymentRepo = paymentRepo;

  @override
  Future<Either<Failure, List<PaymentEntity>>> call(String id) {
    return _paymentRepo.getAllPayments(id);
  }
}
