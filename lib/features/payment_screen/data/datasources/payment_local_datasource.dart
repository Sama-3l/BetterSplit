import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:hive/hive.dart';

abstract class PaymentLocalDatasource {
  Future<void> savePayment(PaymentModel payment);
  Future<void> deletePayment(PaymentModel payment);
  Future<List<PaymentModel>> getCurrentTripPayments(String id);
}

class PaymentLocalDatasourceImpl implements PaymentLocalDatasource {
  static const _paymentBoxName = 'paymentBox';

  @override
  Future<void> savePayment(PaymentModel payment) async {
    final box = await Hive.openBox<PaymentModel>(_paymentBoxName);
    await box.put(payment.id, payment);
  }

  @override
  Future<List<PaymentModel>> getCurrentTripPayments(String id) async {
    final box = await Hive.openBox<PaymentModel>(_paymentBoxName);
    try {
      return box.values.where((e) => e.id == id).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> deletePayment(PaymentModel payment) async {
    final box = await Hive.openBox<PaymentModel>(_paymentBoxName);
    try {
      box.delete(payment.id);
    } catch (_) {}
  }
}
