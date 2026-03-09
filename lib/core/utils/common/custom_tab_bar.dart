import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex; // 0 = home, 1 = account, 2 = qr
  final ValueChanged<int> onTabSelected;

  const CustomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rounded black container for Home & Account buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: ColorsConstants.surfaceBlack, // surfaceBlack
              borderRadius: BorderRadius.circular(48),
            ),
            child: Row(
              children: [
                TabBarButton(
                  index: 0,
                  selectedIndex: selectedIndex,
                  icon: CupertinoIcons.house,
                  filledIcon: CupertinoIcons.house_fill,
                  onSelected: onTabSelected,
                ),
                const SizedBox(width: 24),
                TabBarButton(
                  index: 1,
                  selectedIndex: selectedIndex,
                  icon: CupertinoIcons.person_2,
                  filledIcon: CupertinoIcons.person_2_fill,
                  onSelected: onTabSelected,
                ),
                const SizedBox(width: 24),
                TabBarButton(
                  index: 2,
                  selectedIndex: selectedIndex,
                  icon: CupertinoIcons.person_circle,
                  filledIcon: CupertinoIcons.person_circle_fill,
                  onSelected: onTabSelected,
                ),
              ],
            ),
          ),
          // const SizedBox(width: 16),
          // Floating QR button
          // GestureDetector(
          //   onTap: () => onTabSelected(3),
          //   child: Container(
          //     padding: const EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       color: selectedIndex == 3
          //           ? ColorsConstants
          //                 .accentGreen // accentGreen
          //           : ColorsConstants.surfaceBlack, // surfaceBlack
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: selectedIndex != 3
          //             ? ColorsConstants
          //                   .accentGreen // accentGreen
          //             : ColorsConstants.surfaceBlack,
          //         width: 1,
          //       ),
          //     ),
          //     child: Icon(
          //       Icons.qr_code_scanner,
          //       size: 20,
          //       color: selectedIndex == 3
          //           ? ColorsConstants.surfaceBlack
          //           : ColorsConstants.defaultWhite, // defaultWhite
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class TabBarButton extends StatelessWidget {
  final int index; // index of this button
  final int selectedIndex; // currently selected index
  final IconData icon; // unfilled
  final IconData filledIcon; // filled version
  final ValueChanged<int> onSelected;

  const TabBarButton({
    Key? key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.filledIcon,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsConstants.accentGreen
              : ColorsConstants.surfaceBlack,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Icon(
          isSelected ? filledIcon : icon,
          size: 20,
          color: isSelected
              ? ColorsConstants.surfaceBlack
              : ColorsConstants.defaultWhite,
        ),
      ),
    );
  }
}
