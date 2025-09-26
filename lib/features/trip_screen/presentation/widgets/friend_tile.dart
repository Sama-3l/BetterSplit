import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool subtitle;
  final double titleSize;
  final double circleSize;
  final double spacing;

  final double subtitleSize;
  final ValueChanged<double>? onHeightMeasured;

  const FriendTile({
    super.key,
    this.subtitle = false,
    required this.user,
    this.titleSize = 12,
    this.circleSize = 24,
    this.subtitleSize = 10,
    this.spacing = 8,
    this.onHeightMeasured,
  });

  @override
  Widget build(BuildContext context) {
    final number = user['number'] as String? ?? '';
    final userName = user['userName'] as String? ?? '';
    final name = user['name'] as String? ?? '';

    final parts = Methods.splitNumberParts(number);
    final countryCode = parts['countryCode'] ?? '';
    final part1 = parts['part1'] ?? '';
    final part2 = parts['part2'] ?? '';
    final part3 = parts['part3'] ?? '';

    // A widget to measure height
    // final key = GlobalKey();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (key.currentContext != null && onHeightMeasured != null) {
    //     final box = key.currentContext!.findRenderObject() as RenderBox;
    //     onHeightMeasured!(box.size.height);
    //   }
    // });

    return Row(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorsConstants.defaultWhite,
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorsConstants.backgroundBlack,
              width: 1,
            ),
          ),
          child: Text(
            userName.isNotEmpty ? userName[0] : '',
            style: TextStyles.fustatBold.copyWith(
              fontSize: subtitleSize,
              color: ColorsConstants.backgroundBlack,
            ),
          ),
        ),
        SizedBox(width: spacing),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyles.fustatExtraBold.copyWith(
                  fontSize: titleSize,
                  color: ColorsConstants.defaultWhite,
                  letterSpacing: -0.5,
                ),
              ),
              if (subtitle)
                Text(
                  name,
                  style: TextStyles.fustatExtraBold.copyWith(
                    fontSize: subtitleSize,
                    color: ColorsConstants.defaultWhite.withValues(alpha: 0.5),
                    letterSpacing: -0.5,
                  ),
                ),
            ],
          ),
        ),

        Text(
          '${countryCode != "" ? countryCode : "+91"}-$part1-$part2-$part3',
          style: TextStyles.fustatMedium.copyWith(
            fontSize: 12,
            color: ColorsConstants.defaultWhite,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
