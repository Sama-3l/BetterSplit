import 'package:bettersplitapp/core/utils/common/buttons/primary_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';

class TripHeader extends StatelessWidget {
  final Function() onEditTrip;
  final Function() onMergeFinalQR;

  const TripHeader({
    super.key,
    required this.onEditTrip,
    required this.onMergeFinalQR,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConstants.accentGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      child: Row(
        children: [
          // Expanded(
          //   child: PrimaryButton(
          //     title: "Merge Final QR",
          //     icon: CupertinoIcons.qrcode,
          //     onTap: () => onMergeFinalQR(),
          //   ),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: PrimaryButton(
              title: "Edit Trip",
              iconSize: 20,
              icon: CupertinoIcons.pencil,
              onTap: () => onEditTrip(),
            ),
          ),
        ],
      ),
    );
  }
}
