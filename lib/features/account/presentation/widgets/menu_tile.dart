import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    this.warningTile = false,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final bool warningTile;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsConstants.onSurfaceBlack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: warningTile
                  ? ColorsConstants.warningRed
                  : ColorsConstants.accentGreen,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyles.fustatExtraBold.copyWith(
              fontSize: 16,
              letterSpacing: -0.8,
              color: warningTile
                  ? ColorsConstants.warningRed
                  : ColorsConstants.defaultWhite,
            ),
          ),
          Spacer(),
          // Icon(
          //   CupertinoIcons.chevron_forward,
          //   color: ColorsConstants.warningRed,
          //   size: 12,
          // ),
        ],
      ),
    );
  }
}
