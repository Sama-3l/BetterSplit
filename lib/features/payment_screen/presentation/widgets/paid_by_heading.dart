import 'package:bettersplitapp/features/payment_screen/presentation/blocs/cubits/AddPaymentCubit/add_payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaidByHeading extends StatefulWidget {
  final UserEntity currUser;
  final List<UserEntity> users;

  const PaidByHeading({super.key, required this.currUser, required this.users});

  @override
  State<PaidByHeading> createState() => _PaidByHeadingState();
}

class _PaidByHeadingState extends State<PaidByHeading>
    with TickerProviderStateMixin {
  late FixedExtentScrollController paidByController;
  late FixedExtentScrollController splitOptionController;

  bool showPaidByPicker = false;
  bool showSplitOptionsPicker = false;

  @override
  void initState() {
    final state = context.read<AddPaymentCubit>().state;
    super.initState();
    paidByController = FixedExtentScrollController(
      initialItem: state.paidByUser != null
          ? widget.users.indexWhere((u) => u.id == state.paidByUser!.id)
          : 0,
    );

    splitOptionController = FixedExtentScrollController(
      initialItem: SplitType.values.indexOf(state.selectedSplitOption),
    );
  }

  void _togglePaidByPicker() {
    setState(() {
      showPaidByPicker = !showPaidByPicker;
      showSplitOptionsPicker = false;
    });
  }

  void _toggleSplitPicker() {
    setState(() {
      showSplitOptionsPicker = !showSplitOptionsPicker;
      showPaidByPicker = false;
    });
  }

  @override
  void dispose() {
    paidByController.dispose();
    splitOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPaymentCubit>();
    final state = context.read<AddPaymentCubit>().state;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Paid By',
              style: TextStyles.fustatExtraBold.copyWith(
                fontSize: 12,
                letterSpacing: -0.5,
                color: ColorsConstants.defaultWhite,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: _togglePaidByPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorsConstants.onSurfaceBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.paidByUser == null ||
                          widget.currUser.id == state.paidByUser!.id
                      ? 'You'
                      : state.paidByUser!.userName,
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 12,
                    letterSpacing: -0.5,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Split',
              style: TextStyles.fustatExtraBold.copyWith(
                fontSize: 12,
                letterSpacing: -0.5,
                color: ColorsConstants.defaultWhite,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: _toggleSplitPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorsConstants.onSurfaceBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.selectedSplitOption.value,
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 12,
                    letterSpacing: -0.5,
                    color: ColorsConstants.defaultWhite,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: showPaidByPicker ? 150 : 0,
            child: Stack(
              children: [
                Positioned(
                  top: 55,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorsConstants.surfaceBlack,
                    ),
                  ),
                ),
                ListWheelScrollView.useDelegate(
                  controller: paidByController,
                  itemExtent: 40,
                  perspective: 0.01,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) =>
                      cubit.onPaidUserChange(widget.users[index]),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final user = widget.users[index];
                      return Center(
                        child: Text(
                          widget.currUser.id == user.id ? 'You' : user.userName,
                          style: TextStyles.fustatBold.copyWith(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            color: state.paidByUser?.id == user.id
                                ? ColorsConstants.defaultWhite
                                : ColorsConstants.defaultWhite.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                      );
                    },
                    childCount: widget.users.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: showSplitOptionsPicker ? 150 : 0,
            child: Stack(
              children: [
                Positioned(
                  top: 55,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorsConstants.surfaceBlack,
                    ),
                  ),
                ),
                ListWheelScrollView.useDelegate(
                  controller: splitOptionController,
                  itemExtent: 40,
                  perspective: 0.01,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) =>
                      cubit.onSplitOptionChange(SplitType.values[index]),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final option = SplitType.values[index];
                      return Center(
                        child: Text(
                          option.value,
                          style: TextStyles.fustatBold.copyWith(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            color: state.selectedSplitOption == option
                                ? ColorsConstants.defaultWhite
                                : ColorsConstants.defaultWhite.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                      );
                    },
                    childCount: SplitType.values.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
