import 'package:bettersplitapp/core/utils/constants/widget_decider.dart';
import 'package:flutter/material.dart';

class HorizontalFriendsList extends StatelessWidget {
  final List<String> initials;
  final int limit;
  final bool ltr;

  const HorizontalFriendsList({
    super.key,
    required this.initials,
    this.limit = 4,
    this.ltr = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = initials.length > limit ? limit : initials.length;
    final extraCount = initials.length > limit ? initials.length - limit : 0;

    // Build avatar widgets
    List<Widget> avatars = List.generate(displayCount, (index) {
      return WidgetDecider.buildCircle(initials[index]);
    });

    // Add the +N widget if needed
    if (extraCount > 0) {
      avatars.add(WidgetDecider.buildCircle("+$extraCount"));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
      children: avatars.asMap().entries.map((entry) {
        final idx = entry.key;
        final widget = entry.value;

        // 👇 Key change: offset sign depends on direction
        final offsetX = ltr ? -12.0 * idx : 12.0 * idx;

        return Transform.translate(offset: Offset(offsetX, 0), child: widget);
      }).toList(),
    );
  }
}
