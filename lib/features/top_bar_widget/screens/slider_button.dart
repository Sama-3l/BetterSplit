import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class SliderButton extends StatelessWidget {
  final double progress;
  const SliderButton({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 1 - progress,
          child: Transform.rotate(
            angle: progress * math.pi / 2,
            child: Icon(
              CupertinoIcons.chevron_right_2,
              color: ColorsConstants.defaultWhite,
              size: 24,
            ),
          ),
        ),

        Opacity(
          opacity: progress,
          child: Transform.rotate(
            angle: (-math.pi / 2) + (progress * math.pi / 2),
            child: Transform.scale(
              scale: 0.8 + 0.2 * progress,
              child: Icon(
                CupertinoIcons.check_mark,
                color: ColorsConstants.backgroundBlack,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
