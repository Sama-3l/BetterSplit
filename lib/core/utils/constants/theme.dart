import 'package:flutter/material.dart';

abstract class Fonts {
  //Example
  static String get fustatExtraBold => 'Fustat-ExtraBold';
  static String get fustatSemiBold => 'Fustat-SemiBold';
  static String get fustatRegular => 'Fustat-Regular';
  static String get fustatMedium => 'Fustat-Medium';
  static String get fustatBold => 'Fustat-Bold';
  static String get fustatLight => 'Fustat-Light';
  static String get fustat => 'Fustat';
}

abstract class ColorsConstants {
  static Color get accentGreen => const Color(0xff24F07D);
  static Color get surfaceGreen => const Color(0xFF22D672);
  static Color get backgroundBlack => const Color(0xFF0D0A08);
  static Color get onSurfaceBlack => const Color(0xFF262626);
  static Color get surfaceBlack => const Color(0xFF1A1A1A);
  static Color get defaultWhite => const Color(0xFFFFFFFF);
  static Color get warningRed => const Color(0xFFF63837);
}

class TextStyles {
  //Example
  static TextStyle get fustatExtraBold =>
      TextStyle(fontFamily: Fonts.fustatExtraBold, fontWeight: FontWeight.w800);
  static TextStyle get fustatBold =>
      TextStyle(fontFamily: Fonts.fustatBold, fontWeight: FontWeight.w700);
  static TextStyle get fustatSemiBold =>
      TextStyle(fontFamily: Fonts.fustatSemiBold, fontWeight: FontWeight.w600);
  static TextStyle get fustatMedium =>
      TextStyle(fontFamily: Fonts.fustatMedium, fontWeight: FontWeight.w500);
  static TextStyle get fustatRegular =>
      TextStyle(fontFamily: Fonts.fustatRegular, fontWeight: FontWeight.w400);
  static TextStyle get fustatLight =>
      TextStyle(fontFamily: Fonts.fustatLight, fontWeight: FontWeight.w300);
}

extension TextStyleHelpers on TextStyle {
  TextStyle get accentGreen => copyWith(color: ColorsConstants.accentGreen);
  TextStyle get surfaceGreen => copyWith(color: ColorsConstants.surfaceGreen);
  TextStyle get backgroundBlack =>
      copyWith(color: ColorsConstants.backgroundBlack);
  TextStyle get onSurfaceBlack =>
      copyWith(color: ColorsConstants.onSurfaceBlack);
  TextStyle get surfaceBlack => copyWith(color: ColorsConstants.surfaceBlack);
  TextStyle get defaultWhite => copyWith(color: ColorsConstants.defaultWhite);
  TextStyle get warningRed => copyWith(color: ColorsConstants.warningRed);
}
