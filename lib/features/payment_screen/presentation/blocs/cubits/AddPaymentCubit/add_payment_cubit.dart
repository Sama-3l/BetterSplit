import 'package:bettersplitapp/core/utils/constants/currency_formatter.dart';
import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'add_payment_state.dart';

class AddPaymentCubit extends Cubit<AddPaymentState> {
  AddPaymentCubit()
    : super(
        AddPaymentInitial(
          selectedCurrency: '₹',
          selectedLogo: TripLogo.car,
          paidByUser: null,
          selectedSplitOption: SplitType.equally,
          userShares: [],
          paymentName: '',
          amount: '',
        ),
      );

  initialize(
    String selectedCurrency,
    UserEntity paidByUser,
    List<UserShareEntity> userShares,
  ) {
    final newState = AddPaymentUpdateScreen(
      selectedLogo: state.selectedLogo,
      selectedCurrency: selectedCurrency,
      paidByUser: paidByUser,
      selectedSplitOption: state.selectedSplitOption,
      userShares: userShares,
      paymentName: state.paymentName,
      amount: state.amount,
    );
    emit(newState);
  }

  // addPayment(String title, String amount) {
  //   print(title);
  //   print(amount);
  //   print(state.selectedCurrency);
  //   print(state.selectedLogo);
  //   print(state.selectedSplitOption);
  //   print(state.userShares.map((e) => UserShareModel.fromEntity(e).toJson()));
  // }

  void onCurrencyChange(
    String newCurrency,
    TextEditingController amountController,
  ) {
    // get current raw text
    final oldText = amountController.text;

    // use your formatter to reformat it
    final formatter = CurrencyInputFormatter(newCurrency);

    final newValue = formatter.formatEditUpdate(
      TextEditingValue(text: oldText),
      TextEditingValue(text: oldText),
    );

    // set back to controller
    amountController.value = newValue;

    // finally update the state
    emit(state.copyWith(selectedCurrency: newCurrency));
  }

  onPaidUserChange(UserEntity value) => emit(state.copyWith(paidByUser: value));

  onSplitOptionChange(SplitType value) =>
      emit(state.copyWith(selectedSplitOption: value));

  selectAllFriends(val) {
    for (var userShare in state.userShares) {
      userShare.isIncluded = val;
      if (userShare.isIncluded) {
        userShare.amount =
            Methods.safeParse(state.amount) / state.userShares.length;
      } else {
        userShare.amount = 0;
      }
    }
    emit(state.copyWith());
  }

  selectCurrentFriend(int index) {
    state.userShares[index].isIncluded = !state.userShares[index].isIncluded;
    final included = state.userShares.where((e) => e.isIncluded).length;
    for (var userShare in state.userShares) {
      if (userShare.isIncluded) {
        userShare.amount = Methods.safeParse(state.amount) / included;
      }
    }
    emit(state.copyWith());
  }

  void onPaymentNameChanged(String value) {
    emit(state.copyWith(paymentName: value));
  }

  void onAmountChanged(String value) {
    if (state.selectedSplitOption == SplitType.percentage) {
      for (var userShare in state.userShares) {
        if (userShare.percentage != null && userShare.percentage != 0) {
          userShare.amount =
              (userShare.percentage ?? 0) * Methods.safeParse(value) * 0.01;
        }
      }
    } else if (state.selectedSplitOption == SplitType.equally) {
      final included = state.userShares.where((e) => e.isIncluded).length;
      for (var userShare in state.userShares) {
        if (userShare.isIncluded) {
          userShare.amount = Methods.safeParse(value) / included;
        }
      }
    }
    emit(state.copyWith(amount: value, userShares: state.userShares));
  }

  updateUserShares(List<UserShareEntity> userShares) =>
      emit(state.copyWith(userShares: userShares));
}
