// lib/widgets/primary_button.dart
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool secondary;
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    this.secondary = false,
    this.title = "Apply",
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondary
              ? ColorsConstants.surfaceGreen
              : ColorsConstants.backgroundBlack,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyles.fustatBold.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.8,
                color: secondary
                    ? ColorsConstants.backgroundBlack
                    : ColorsConstants.defaultWhite,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(
                icon,
                size: 12,
                color: secondary
                    ? ColorsConstants.backgroundBlack
                    : ColorsConstants.defaultWhite,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
