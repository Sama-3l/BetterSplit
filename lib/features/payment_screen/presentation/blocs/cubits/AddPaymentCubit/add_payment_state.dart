part of 'add_payment_cubit.dart';

@immutable
sealed class AddPaymentState {
  final String paymentName;
  final String amount;
  final TripLogo selectedLogo;
  final String selectedCurrency;
  final UserEntity? paidByUser;
  final SplitType selectedSplitOption;
  final List<UserShareEntity> userShares;

  const AddPaymentState({
    required this.paymentName,
    required this.amount,
    required this.selectedLogo,
    required this.selectedCurrency,
    required this.paidByUser,
    required this.selectedSplitOption,
    required this.userShares,
  });

  AddPaymentState copyWith({
    String? paymentName,
    String? amount,
    TripLogo? selectedLogo,
    String? selectedCurrency,
    UserEntity? paidByUser,
    SplitType? selectedSplitOption,
    List<UserShareEntity>? userShares,
  }) {
    // return the same runtimeType state but updated fields
    if (this is AddPaymentInitial) {
      return AddPaymentInitial(
        selectedLogo: selectedLogo ?? this.selectedLogo,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        paidByUser: paidByUser ?? this.paidByUser,
        selectedSplitOption: selectedSplitOption ?? this.selectedSplitOption,
        userShares: userShares ?? this.userShares,
        paymentName: paymentName ?? this.paymentName,
        amount: amount ?? this.amount,
      );
    } else {
      return AddPaymentUpdateScreen(
        selectedLogo: selectedLogo ?? this.selectedLogo,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        paidByUser: paidByUser ?? this.paidByUser,
        selectedSplitOption: selectedSplitOption ?? this.selectedSplitOption,
        userShares: userShares ?? this.userShares,
        paymentName: paymentName ?? this.paymentName,
        amount: amount ?? this.amount,
      );
    }
  }
}

final class AddPaymentInitial extends AddPaymentState {
  const AddPaymentInitial({
    required super.selectedLogo,
    required super.selectedCurrency,
    required super.paidByUser,
    required super.selectedSplitOption,
    required super.userShares,
    required super.paymentName,
    required super.amount,
  });
}

final class AddPaymentUpdateScreen extends AddPaymentState {
  const AddPaymentUpdateScreen({
    required super.selectedLogo,
    required super.selectedCurrency,
    required super.paidByUser,
    required super.selectedSplitOption,
    required super.userShares,
    required super.paymentName,
    required super.amount,
  });
}
