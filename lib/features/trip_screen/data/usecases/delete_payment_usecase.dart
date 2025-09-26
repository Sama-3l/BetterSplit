import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/repo/payment_repo.dart';
import 'package:dartz/dartz.dart';

class DeletePaymentUseCase extends UseCase<void, PaymentEntity> {
  final PaymentRepo _paymentRepository;

  DeletePaymentUseCase(this._paymentRepository);

  @override
  Future<Either<Failure, void>> call(PaymentEntity entity) {
    return _paymentRepository.deletePayment(entity);
  }
}
