import 'package:bettersplitapp/core/utils/common/textfield.dart';
import 'package:bettersplitapp/core/utils/constants/currency_formatter.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/blocs/cubits/AddPaymentCubit/add_payment_cubit.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/widgets/add_payment_header.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/widgets/friends_shares.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/widgets/paid_by_heading.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPaymentBottomSheet extends StatefulWidget {
  final UserEntity currUser;
  final TripEntity trip;
  final void Function(PaymentEntity payment)? onAdd;

  const AddPaymentBottomSheet({
    super.key,
    required this.currUser,
    required this.trip,
    this.onAdd,
  });

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final _paymentNameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values
    _paymentNameController.text = context
        .read<AddPaymentCubit>()
        .state
        .paymentName;
    _amountController.text = context.read<AddPaymentCubit>().state.amount;

    _paymentNameController.addListener(() {
      context.read<AddPaymentCubit>().onPaymentNameChanged(
        _paymentNameController.text,
      );
    });
    _amountController.addListener(() {
      context.read<AddPaymentCubit>().onAmountChanged(_amountController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.9;

    return BlocBuilder<AddPaymentCubit, AddPaymentState>(
      builder: (context, state) {
        final cubit = context.read<AddPaymentCubit>();
        // print(widget.trip.payments);
        return Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Container(
              height: height,
              color: ColorsConstants.backgroundBlack,
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddPaymentHeader(
                        paymentName: _paymentNameController,
                        trip: widget.trip,
                        users: widget.trip.users,
                        onApply: () {
                          final peoplePresent = state.userShares.where(
                            (e) => e.isIncluded,
                          );

                          if (peoplePresent.isNotEmpty) {
                            for (var s in state.userShares) {
                              s.isIncluded =
                                  s.isIncluded ||
                                  (s.amount != null && s.amount != 0);
                            }
                            final payment = Methods.addPayment(
                              title: _paymentNameController.text,
                              trip: widget.trip,
                              paidByUser: state.paidByUser!,
                              amount: Methods.safeParse(state.amount),
                              userShares: state.userShares,
                            );
                            Navigator.of(context).pop(payment);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      Column(
                        children: [
                          InputField(
                            title: "Payment Name",
                            hintText: "Dominos",
                            controller: _paymentNameController,
                            maxLength: 20,
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            title: "Amount",
                            hintText: "300.00",
                            textInputType: TextInputType.number,
                            formatters: [
                              CurrencyInputFormatter(state.selectedCurrency),
                            ],
                            controller: _amountController,
                            selectedCurrency: state.selectedCurrency,
                            onCurrencyChange: (value) => cubit.onCurrencyChange(
                              value,
                              _amountController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      PaidByHeading(
                        currUser: widget.currUser,
                        users: widget.trip.users,
                      ),
                      FriendsShares(
                        amountController: _amountController,
                        currUser: widget.currUser,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
