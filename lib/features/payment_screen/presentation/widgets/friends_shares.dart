import 'package:bettersplitapp/core/utils/common/buttons/toggle_button.dart';
import 'package:bettersplitapp/core/utils/common/textfield.dart';
import 'package:bettersplitapp/core/utils/constants/currency_formatter.dart';
import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/core/utils/constants/widget_decider.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/blocs/cubits/AddPaymentCubit/add_payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsShares extends StatefulWidget {
  final TextEditingController amountController;
  final UserEntity currUser;

  const FriendsShares({
    super.key,
    required this.amountController,
    required this.currUser,
  });

  @override
  State<FriendsShares> createState() => _FriendsSharesState();
}

class _FriendsSharesState extends State<FriendsShares> {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  @override
  void initState() {
    super.initState();
    final state = context.read<AddPaymentCubit>().state;
    for (var share in state.userShares) {
      controllers[share.user.id] = TextEditingController();
      focusNodes[share.user.id] = FocusNode();
    }
    controllers.forEach((userId, controller) {
      controller.addListener(() {
        Methods.updateTotalFromFriends(
          context.read<AddPaymentCubit>().state,
          controllers,
          widget.amountController,
        );
      });
    });
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    for (var f in focusNodes.values) {
      f.dispose();
    }
    controllers.forEach((userId, controller) {
      controller.removeListener(() {
        Methods.updateTotalFromFriends(
          context.read<AddPaymentCubit>().state,
          controllers,
          widget.amountController,
        );
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPaymentCubit>();
    final state = context.read<AddPaymentCubit>().state;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsConstants.surfaceBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (state.selectedSplitOption == SplitType.equally) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All",
                  style: TextStyles.fustatExtraBold.copyWith(
                    fontSize: 12,
                    letterSpacing: -0.5,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
                SmallToggleButton(
                  initialValue: state.userShares.every((u) => u.isIncluded),
                  onChanged: (val) => cubit.selectAllFriends(val),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.userShares.length,
            itemBuilder: (context, index) {
              final userShare = state.userShares[index];
              final controller = controllers[userShare.user.id]!;
              final focusNode = focusNodes[userShare.user.id]!;
              final focusNotifier = ValueNotifier<bool>(focusNode.hasFocus);

              focusNode.addListener(() {
                focusNotifier.value = focusNode.hasFocus;
              });
              return ValueListenableBuilder<bool>(
                valueListenable: focusNotifier,
                builder: (context, value, _) {
                  return Row(
                    children: [
                      WidgetDecider.buildCircle(
                        widget.currUser.id == userShare.user.id
                            ? 'Y'
                            : userShare.user.userName.characters.first,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.currUser.id == userShare.user.id
                                  ? "You"
                                  : userShare.user.userName,
                              style: TextStyles.fustatExtraBold.copyWith(
                                fontSize: 12,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                                color: ColorsConstants.defaultWhite,
                              ),
                            ),
                            if (state.selectedSplitOption ==
                                SplitType.percentage)
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, value, child) {
                                  final percent = Methods.safeParse(value.text);
                                  final amount = Methods.safeParse(
                                    widget.amountController.text,
                                  );
                                  final total = amount * percent / 100.0;
                                  return Text(
                                    '${state.selectedCurrency}${total.toStringAsFixed(2)}',
                                    style: TextStyles.fustatExtraBold.copyWith(
                                      letterSpacing: -0.5,
                                      fontSize: 10,
                                      color: ColorsConstants.defaultWhite
                                          .withValues(alpha: 0.5),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      if (state.selectedSplitOption == SplitType.equally)
                        SmallToggleButton(
                          initialValue: userShare.isIncluded,
                          onChanged: (value) =>
                              cubit.selectCurrentFriend(index),
                        ),

                      if (state.selectedSplitOption == SplitType.unequally)
                        SizedBox(
                          width: 100,
                          child: InputField(
                            padding: EdgeInsets.zero,
                            formatters: [
                              CurrencyInputFormatter(state.selectedCurrency),
                            ],
                            hintText: "0.00",
                            focusNode: focusNode,
                            prefixIcon: Align(
                              alignment: Alignment.center,
                              child: Text(
                                state.selectedCurrency,
                                style: TextStyles.fustatBold.copyWith(
                                  fontSize: 12,
                                  color: focusNotifier.value
                                      ? ColorsConstants.defaultWhite
                                      : ColorsConstants.defaultWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            controller: controller,
                            textInputType: TextInputType.number,
                          ),
                        ),
                      if (state.selectedSplitOption == SplitType.percentage)
                        SizedBox(
                          width: 100,
                          child: InputField(
                            padding: EdgeInsets.zero,
                            focusNode: focusNode,
                            controller: controller,
                            textInputType: TextInputType.number,
                            hintText: '0',
                            suffixIcon: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '%',
                                  style: TextStyles.fustatBold.copyWith(
                                    fontSize: 12,
                                    color: focusNotifier.value
                                        ? ColorsConstants.defaultWhite
                                        : ColorsConstants.defaultWhite
                                              .withValues(alpha: 0.5),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
