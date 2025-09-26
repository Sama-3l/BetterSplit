import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final List<Widget> options;
  final Function(String search) onSearch;

  TripsHeaderDelegate({
    required this.title,
    required this.options,
    required this.onSearch,
  });

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: ColorsConstants.backgroundBlack, // keep consistent with background
      padding: const EdgeInsets.only(left: 16, right: 8),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.fustatSemiBold.copyWith(
              color: ColorsConstants.defaultWhite,
              fontSize: 24,
              letterSpacing: -1.6,
            ),
          ),
          const Spacer(),
          ...options,
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TripsHeaderDelegate oldDelegate) => false;
}

class TripsHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  final Function(String search) onSearch;

  const TripsHeaderWidget({
    super.key,
    required this.title,
    required this.onAdd,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // since your sliver’s minExtent/maxExtent was 60
      color: ColorsConstants.backgroundBlack,
      padding: const EdgeInsets.only(left: 16, right: 8),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.fustatSemiBold.copyWith(
              color: ColorsConstants.defaultWhite,
              fontSize: 24,
              letterSpacing: -1.6,
            ),
          ),
          const Spacer(),
          CircularButton(
            icon: CupertinoIcons.search,
            color: ColorsConstants.defaultWhite,
            onTap: () => onSearch(""),
          ),
          const SizedBox(width: 8),
          CircularButton(
            icon: CupertinoIcons.add,
            color: ColorsConstants.defaultWhite,
            onTap: () => onAdd(),
          ),
        ],
      ),
    );
  }
}
