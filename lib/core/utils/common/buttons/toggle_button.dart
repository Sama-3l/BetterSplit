import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';

class SmallToggleButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SmallToggleButton({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<SmallToggleButton> createState() => _SmallToggleButtonState();
}

class _SmallToggleButtonState extends State<SmallToggleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.initialValue);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorsConstants.defaultWhite, width: 1),
        ),
        width: 18,
        height: 18,
        child: Center(
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: widget.initialValue
                  ? ColorsConstants.accentGreen
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }
}
