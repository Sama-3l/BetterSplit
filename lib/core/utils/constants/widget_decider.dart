import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';

class WidgetDecider {
  static Widget buildCircle(String text) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorsConstants.defaultWhite,
        shape: BoxShape.circle,
        border: Border.all(color: ColorsConstants.backgroundBlack, width: 1),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyles.fustatBold.copyWith(
          fontSize: 16,
          color: ColorsConstants.backgroundBlack,
        ),
      ),
    );
  }
}
