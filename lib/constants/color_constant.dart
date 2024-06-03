import 'package:flutter/material.dart';
import 'package:knovator_task/constants/sizeConstant.dart';

class BaseTheme {
  Color get primaryTheme => fromHex("#133BDC");
  Color get primaryDarkTheme => fromHex("#10109D");
  Color get primaryDarkTextColor => fromHex("#000026");
  Color get primaryLightTextColor => fromHex("#6A6D71");
  Color get primaryTextColor => fromHex("#FFFFFF");

  Color get secondaryColor => fromHex("#10109D");
  Color get secondaryDarkColor => fromHex("#10109D");
  Color get secondaryDarkTextColor => fromHex("#000026");
  Color get secondaryLightColor => fromHex("#FFB347");
  Color get secondaryLightTextColor => fromHex("#6A6E72");
  Color get lightGrayColor => fromHex("#F0EFF4");
  Color get buttonDisableColor => fromHex("#A3A3A3");

  Color get textGrayColor => fromHex("#f1f1f1");
  Color get splashDotColor => fromHex("#B6B5FE");
  Color get activeSplashDotColor => fromHex("#11109C");

  List<BoxShadow> get getShadow {
    return [
      BoxShadow(
        offset: Offset(2, 2),
        color: Colors.black26,
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
      BoxShadow(
        offset: Offset(-1, -1),
        color: Colors.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
    ];
  }

  List<BoxShadow> get getShadow3 {
    return [
      BoxShadow(
        offset: Offset(2, 2),
        color: Colors.black12,
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
      BoxShadow(
        offset: Offset(-1, -1),
        color: Colors.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
    ];
  }

  List<BoxShadow> get getShadow2 {
    return [
      BoxShadow(
          offset: Offset(MySize.getWidth(2.5), MySize.getHeight(2.5)),
          color: Color(0xffAEAEC0).withOpacity(0.4),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
      BoxShadow(
          offset: Offset(MySize.getWidth(-2.5), MySize.getHeight(-2.5)),
          color: Color(0xffFFFFFF).withOpacity(0.4),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
    ];
  }
}

BaseTheme get appTheme => BaseTheme();

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
