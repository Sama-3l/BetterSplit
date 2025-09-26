import 'package:bettersplitapp/features/top_bar_widget/SliderAnimationCubit/slider_animation_cubit.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/receiver_info.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/slider_button.dart';
import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

class MakePaymentSlider extends StatefulWidget {
  final LedgerEntity ledger;
  final VoidCallback onSwiped;

  const MakePaymentSlider({
    super.key,
    required this.ledger,
    required this.onSwiped,
  });

  @override
  State<MakePaymentSlider> createState() => _MakePaymentSliderState();
}

class _MakePaymentSliderState extends State<MakePaymentSlider> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderAnimationCubit, SliderAnimationState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cubit = context.read<SliderAnimationCubit>();
            double offsetX = state.offsetX;
            final maxLimit = constraints.maxWidth - 64;
            final progress = offsetX / maxLimit;
            return Container(
              height: 64,
              decoration: BoxDecoration(
                color: ColorsConstants.surfaceGreen,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Methods.interpolate(
                          ColorsConstants.defaultWhite,
                          ColorsConstants.backgroundBlack,
                          progress,
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 1 - progress,
                        child: ReceiverInfo(ledger: widget.ledger),
                      ),
                    ),
                  ),

                  Positioned(
                    left: offsetX,
                    top: 4,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) => cubit.update(
                        math.min(
                          math.max(details.localPosition.dx, 0),
                          maxLimit,
                        ),
                      ),
                      onHorizontalDragEnd: (_) {
                        if (offsetX >= maxLimit * 0.95) {
                          widget.onSwiped();
                          cubit.update(maxLimit);
                        } else {
                          cubit.update(0.0);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Methods.interpolate(
                              ColorsConstants.backgroundBlack,
                              ColorsConstants.accentGreen,
                              progress,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: SliderButton(progress: progress),
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: progress,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Complete",
                              style: TextStyles.fustatExtraBold.copyWith(
                                fontSize: 12,
                                letterSpacing: -0.4,
                                color: ColorsConstants.accentGreen,
                              ),
                            ),
                            Text(
                              "Payment Now!",
                              style: TextStyles.fustatExtraBold.copyWith(
                                fontSize: 16,
                                letterSpacing: -0.4,
                                color: ColorsConstants.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
