import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/data/entities/update_trip_usecase_entity.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/delete_payment_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/get_all_payments_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/update_trip_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  final GetAllPaymentsUsecase getAllPaymentsUsecase;
  final UpdateTripUsecase updateTripUsecase;
  final DeletePaymentUseCase deletePaymentUseCase;

  TripScreenCubit({
    required this.getAllPaymentsUsecase,
    required this.updateTripUsecase,
    required this.deletePaymentUseCase,
  }) : super(TripScreenInitial());

  initialize(TripEntity trip) async {
    emit(TripScreenInitial(trip: trip));
  }

  updateTrip(TripEntity trip) async {
    final entity = UpdateTripUsecaseEntity(
      title: trip.title,
      icon: trip.icon,
      tripId: trip.id,
      selectedCurrency: trip.selectedCurrency,
      netBalance: trip.netBalance,
      ledger: trip.ledger.map((e) => LedgerModel.fromEntity(e)).toList(),
      payments: trip.payments.map((e) => PaymentModel.fromEntity(e)).toList(),
    );
    await updateTripUsecase(entity);
    emit(UpdateTrip(trip: trip));
  }

  deletePayment(
    PaymentEntity payment,
    TripEntity trip,
    UserEntity currUser,
  ) async {
    for (var s in payment.shares) {
      s.isIncluded = s.isIncluded || (s.amount != null && s.amount != 0);
    }
    final netBalance = Map<String, double>.from(trip.netBalance);

    netBalance[payment.payer.number] =
        (netBalance[payment.payer.number] ?? 0) - payment.amount;

    for (final share in payment.shares) {
      if (share.isIncluded) {
        netBalance[share.user.number] =
            (netBalance[share.user.number] ?? 0) + (share.amount ?? 0);
      }
    }

    final sortedByValueAscending =
        netBalance.entries.map((e) => {'key': e.key, 'value': e.value}).toList()
          ..sort(
            (a, b) => (a['value'] as double).compareTo(b['value'] as double),
          );

    final userLookup = {for (var u in trip.users) u.number: u};

    int left = 0;
    int right = sortedByValueAscending.length - 1;
    List<LedgerEntity> ledgers = [];
    // trip.ledger.clear();

    while (left < right) {
      double debit = -((sortedByValueAscending[left]['value']) as double);
      double credit = (sortedByValueAscending[right]['value']) as double;
      double settlement = debit < credit ? debit : credit;

      sortedByValueAscending[left]['value'] =
          (sortedByValueAscending[left]['value'] as double) + settlement;
      sortedByValueAscending[right]['value'] =
          (sortedByValueAscending[right]['value'] as double) - settlement;

      if (settlement > 0) {
        final payer = userLookup[sortedByValueAscending[left]['key'] as String];
        final receiver =
            userLookup[sortedByValueAscending[right]['key'] as String];

        if (payer != null && receiver != null) {
          final ledgerEntry = LedgerEntity(
            id: Uuid().v4(),
            trip: trip,
            payer: payer,
            friend: receiver,
            amount: settlement,
          );
          // trip.ledger.add(ledgerEntry);
          ledgers.add(ledgerEntry);
        }
      }

      if (((sortedByValueAscending[left]['value']) as double).abs() < 1e-9) {
        left++;
      }
      if (((sortedByValueAscending[right]['value']) as double).abs() < 1e-9) {
        right--;
      }
    }
    // print("\n");
    // print(
    //   ledgers.map((e) => "${e.payer.name} -> ${e.friend.name} : ${e.amount}"),
    // );
    // print(netBalance);
    // print("\n");
    // await deletePaymentUseCase(payment);
  }

  getPayments() async {}
}
