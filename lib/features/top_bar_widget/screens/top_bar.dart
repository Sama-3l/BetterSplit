import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool backButton;
  final double radius;
  final double topPadding;
  final double size;
  final VoidCallback onTap;

  const TopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.backButton = false,
    this.topPadding = 56,
    this.radius = 0,
    this.size = 40,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConstants.accentGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      ),
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16),
      child: Row(
        children: [
          if (backButton)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircularButton(
                onTap: () => GoRouter.of(context).pop(),
                icon: CupertinoIcons.arrow_left,
                size: size,
                color: ColorsConstants.backgroundBlack,
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Text(
                          subtitle!,
                          style: TextStyles.fustatBold.backgroundBlack.copyWith(
                            fontSize: 16,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    title,
                    style: TextStyles.fustatBold.backgroundBlack.copyWith(
                      fontSize: 32,
                      letterSpacing: -1.6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
